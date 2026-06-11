# Lab 3: SLA Compliance, Operational Reporting & Blameless Postmortem

**Estimated time:** 45–50 minutes  
**Tools needed:** AWS Console, SSH terminal, Microsoft Excel or Google Sheets

**Prerequisite:** Lab 2 EC2 instance (`payment-processor` service) is running and fixed.

**AWS region:** Canada (Central) — `ca-central-1`

> **Optional:** Copy [template/lab3_starter.xlsx](template/lab3_starter.xlsx) instead of creating sheets from scratch in Step 8.

---

## Lab Objectives

By the end of this lab, you will be able to:

- Collect real metrics from AWS CloudWatch
- Calculate SLA compliance, MTTR, MTBF, and availability
- Build a KPI dashboard in CloudWatch
- Export data to Excel for analysis
- Write a blameless postmortem
- Create a runbook (SOP)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           AWS Cloud                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    EC2 Instance (Lab 2)                          │   │
│  │  • payment-processor service                                     │   │
│  │  • CloudWatch Agent installed                                    │   │
│  │  • Sends metrics: CPU, Memory, Custom errors                     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                    │
│                                    ▼                                    │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    Amazon CloudWatch                             │   │
│  │  • Metrics collected                                             │   │
│  │  • Dashboard created                                             │   │
│  │  • Alarms configured                                             │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                    │
│                                    ▼                                    │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    Excel (Local)                                 │   │
│  │  • Export data from CloudWatch                                  │   │
│  │  • Calculate MTTR, MTBF, Availability                           │   │
│  │  • Create SLA dashboard                                          │   │
│  │  • Write postmortem & runbook                                    │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Step 1 — Verify Your Lab 2 EC2 Instance is Running

1. Sign in to the **AWS Console** and set the region to **Canada (Central)**.
2. Go to **EC2** → **Instances**.
3. Locate your Lab 2 instance (e.g. `Lab2-Broken-System`).
4. Verify **Instance state** = `Running`.
5. Note the **Public IPv4 address**.

---

## Step 2 — SSH into Your EC2 Instance

**Mac/Linux:**

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<your-instance-public-ip>
```

**Windows (PowerShell):**

```powershell
ssh -i your-key.pem ec2-user@<your-instance-public-ip>
```

You should see a prompt like `[ec2-user@ip-... ~]$`.

Verify the service from Lab 2 is still healthy:

```bash
systemctl is-active payment-processor
```

Expect: `active`

---

## Step 3 — Install CloudWatch Agent on EC2

Run in your SSH session:

```bash
sudo yum install -y amazon-cloudwatch-agent
```

**Option A — copy the config file from your machine (recommended):**

```bash
# Run on your local machine (not on EC2):
scp -i your-key.pem setup/cloudwatch_agent_config.json ec2-user@<public-ip>:/tmp/
```

Then on the EC2 instance:

```bash
sudo cp /tmp/cloudwatch_agent_config.json /opt/aws/amazon-cloudwatch-agent/bin/config.json
```

**Option B — create the config on the instance:**

```bash
sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json > /dev/null << 'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"],
        "metrics_collection_interval": 60,
        "totalcpu": true
      },
      "mem": {
        "measurement": ["mem_used_percent", "mem_free"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["disk_used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["/"]
      }
    },
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}",
      "InstanceType": "${aws:InstanceType}"
    }
  }
}
EOF
```

Start the agent and verify:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

sudo systemctl status amazon-cloudwatch-agent
```

Expect: `active (running)`

---

## Step 4 — Create Custom Metrics for payment-processor

The EC2 instance needs permission to publish metrics. Your instructor attaches an IAM role before class (see instructor setup guide). If `aws cloudwatch put-metric-data` fails with **AccessDenied**, ask your instructor.

Install cron support (required on Amazon Linux 2023):

```bash
sudo yum install -y cronie
```

**Option A — copy the script from your machine (recommended):**

```bash
# On your local machine:
scp -i your-key.pem setup/send_metrics.sh ec2-user@<public-ip>:/tmp/
```

On the instance:

```bash
sudo cp /tmp/send_metrics.sh /opt/send_metrics.sh
sudo chmod +x /opt/send_metrics.sh
```

**Option B — create the script on the instance:**

```bash
sudo tee /opt/send_metrics.sh > /dev/null << 'EOF'
#!/bin/bash
set -euo pipefail
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

if systemctl is-active --quiet payment-processor; then
  SERVICE_STATUS=1
else
  SERVICE_STATUS=0
fi

aws cloudwatch put-metric-data \
  --namespace "PaymentProcessor" \
  --metric-name "ServiceHealth" \
  --value "$SERVICE_STATUS" \
  --unit Count \
  --dimensions InstanceId="$INSTANCE_ID" \
  --region ca-central-1

RANDOM_TIME=$((RANDOM % 200 + 50))
aws cloudwatch put-metric-data \
  --namespace "PaymentProcessor" \
  --metric-name "ResponseTimeMs" \
  --value "$RANDOM_TIME" \
  --unit Milliseconds \
  --dimensions InstanceId="$INSTANCE_ID" \
  --region ca-central-1

echo "Metrics sent at $(date) status=$SERVICE_STATUS response_ms=$RANDOM_TIME"
EOF
sudo chmod +x /opt/send_metrics.sh
```

Schedule the script every 5 minutes and run it once:

```bash
(crontab -l 2>/dev/null | grep -v send_metrics.sh; echo "*/5 * * * * /opt/send_metrics.sh >> /var/log/send_metrics.log 2>&1") | crontab -
/opt/send_metrics.sh
```

Expect output like: `Metrics sent at ... status=1 response_ms=...`

**Optional — simulate downtime for richer metrics:**

```bash
sudo systemctl stop payment-processor
/opt/send_metrics.sh
sudo systemctl start payment-processor
/opt/send_metrics.sh
```

---

## Step 5 — Create a CloudWatch Dashboard

1. In the AWS Console, open **CloudWatch** → **Dashboards** → **Create dashboard**.
2. Name: `Lab3-SLA-Dashboard`
3. Click **Add widget** and add:

| Widget type | Metric | Purpose |
|-------------|--------|---------|
| Line | **EC2** → **CPUUtilization** (your instance) | Track server load |
| Line | **EC2** → **StatusCheckFailed** (your instance) | Track instance health |
| Line | **PaymentProcessor** → **ServiceHealth** | Service up (1) or down (0) |
| Line | **PaymentProcessor** → **ResponseTimeMs** | API response time |
| Number | **PaymentProcessor** → **ServiceHealth** (Average) | Current service status |
| Number | **EC2** → **CPUUtilization** (Average) | Average CPU load |

4. Save the dashboard.

> Custom metrics may take a few minutes to appear. Refresh the dashboard after Step 4.

---

## Step 6 — Create CloudWatch Alarms for SLA Monitoring

Run from your **SSH session** (region must match your console):

**Alarm 1 — Service Down (P1 incident):**

```bash
aws cloudwatch put-metric-alarm \
  --region ca-central-1 \
  --alarm-name "PaymentProcessor-ServiceDown" \
  --alarm-description "Alert when payment-processor service stops" \
  --metric-name "ServiceHealth" \
  --namespace "PaymentProcessor" \
  --statistic Average \
  --period 60 \
  --evaluation-periods 1 \
  --threshold 0.5 \
  --comparison-operator LessThanThreshold \
  --treat-missing-data breaching
```

**Alarm 2 — High response time (SLA breach risk):**

```bash
aws cloudwatch put-metric-alarm \
  --region ca-central-1 \
  --alarm-name "PaymentProcessor-HighResponseTime" \
  --alarm-description "Response time exceeding 200ms (SLA risk)" \
  --metric-name "ResponseTimeMs" \
  --namespace "PaymentProcessor" \
  --statistic Average \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 200 \
  --comparison-operator GreaterThanThreshold
```

Verify in the console: **CloudWatch** → **Alarms** → both alarms listed (`OK`, `ALARM`, or `INSUFFICIENT_DATA`).

> SNS notifications are optional. Add `--alarm-actions` only if your instructor provides an SNS topic ARN.

---

## Step 7 — Export CloudWatch Data

**Console method:**

1. **CloudWatch** → **Metrics** → **All metrics**
2. Open namespace **PaymentProcessor** → **ServiceHealth**
3. Select your instance dimension
4. Open the **Graphed metrics** tab
5. **Actions** → **Download CSV**

**CLI method (from SSH):**

```bash
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

aws cloudwatch get-metric-statistics \
  --region ca-central-1 \
  --namespace "PaymentProcessor" \
  --metric-name "ServiceHealth" \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --start-time "$(date -u -d '1 hour ago' --iso-seconds)" \
  --end-time "$(date -u --iso=seconds)" \
  --period 300 \
  --statistics Average
```

---

## Step 8 — Create Excel Workbook

Open Excel and create `lab3_sla_metrics.xlsx` with these sheets:

| Sheet name | Purpose |
|------------|---------|
| Raw Metrics | Paste exported CloudWatch data |
| SLA Calculations | Response time and resolution compliance |
| MTTR MTBF | Reliability metrics |
| Availability | Uptime percentage |
| KPI Dashboard | Summary dashboard |
| Postmortem | Blameless postmortem (Step 12) |
| Runbook | SOP (Step 13) |

---

## Step 9 — Calculate SLA Metrics

In the **SLA Calculations** sheet, build a table from your CloudWatch data (or use this sample if metrics are sparse):

| Timestamp | ServiceHealth (1=up, 0=down) | ResponseTimeMs |
|-----------|------------------------------|----------------|
| 09:00 | 1 | 95 |
| 09:05 | 1 | 102 |
| 09:10 | 0 | — |
| 09:15 | 0 | — |
| 09:20 | 1 | 180 |
| 09:25 | 1 | 88 |

**SLA targets:**

- P1 response: 5 minutes
- P1 resolution: 1 hour
- Response time threshold: 150 ms

**Calculate:**

- **Downtime minutes** — count rows where ServiceHealth = 0, multiply by 5 (interval length)
- **Response SLA compliance** — `(readings ≤ 150 ms) ÷ (total readings with data) × 100`
- **Any response times over 150 ms?** — note which timestamps

---

## Step 10 — Calculate MTTR, MTBF, and Availability

In the **MTTR MTBF** sheet:

| Metric | Formula |
|--------|---------|
| **MTTR** | Total downtime minutes ÷ number of incidents |
| **MTBF** | Total uptime minutes ÷ number of failures |
| **Availability** | (Total time − downtime) ÷ total time × 100 |

**Example (from sample data above):**

| Metric | Value |
|--------|-------|
| Total time | 60 minutes |
| Downtime | 10 minutes |
| Uptime | 50 minutes |
| Incidents | 1 |
| **MTTR** | 10 ÷ 1 = **10 minutes** |
| **MTBF** | 50 ÷ 1 = **50 minutes** |
| **Availability** | (60 − 10) ÷ 60 × 100 = **83.33%** |

Record your values from your own data in the **Availability** sheet.

---

## Step 11 — Create KPI Dashboard in Excel

In the **KPI Dashboard** sheet, fill in:

```
WEEKLY KPI DASHBOARD
Date: _______________

SERVICE HEALTH
Service Availability:        _______ %
Total Downtime (min):        _______
Number of Incidents:         _______

SLA COMPLIANCE
Response SLA:                _______ %
Resolution SLA:              _______ %
Overall SLA:                 _______ %

RELIABILITY METRICS
MTTR (minutes):              _______
MTBF (minutes):              _______

TOP ALERTS
1. Service Down:             _______ times
2. High Response Time:       _______ times

ACTION ITEMS
1.
2.
3.
```

---

## Step 12 — Write Blameless Postmortem

In the **Postmortem** sheet, document the Lab 2 incident using your CloudWatch timeline:

```
BLAMELESS POSTMORTEM — Incident ID: INC-AWS-001

DATE:         _______________
SERVICE:      payment-processor
SEVERITY:     P1
SLA MET?      Yes / No

WHAT HAPPENED?
[Describe based on CloudWatch ServiceHealth and Lab 2 root cause]

WHEN?
Start time:   _______________
End time:     _______________
Duration:     _______________ minutes

5 WHYS
1. Why did the service fail? →
2. Why did that happen? →
3. Why did that happen? →
4. Why did that happen? →
5. Why did that happen? →
Root cause:

WHAT WENT WELL?
•

WHAT WENT WRONG?
•

ACTION ITEMS
| Action | Owner | Due Date |
|--------|-------|----------|

LESSONS LEARNED
•
```

---

## Step 13 — Create Runbook (SOP)

In the **Runbook** sheet:

```
RUNBOOK / SOP — Document ID: RB-AWS-001
TITLE: payment-processor Service Recovery

TRIGGER
• CloudWatch alarm: PaymentProcessor-ServiceDown
• User reports: transactions failing

STEP 1 — ACKNOWLEDGE
• Acknowledge alarm; note incident time
• Check Lab3-SLA-Dashboard for impact duration

STEP 2 — CHECK SERVICE STATUS
  systemctl status payment-processor

STEP 3 — CHECK LOGS
  sudo journalctl -u payment-processor -n 50
  Look for: "address already in use" or port 8080

STEP 4 — CHECK PORT CONFLICT
  sudo ss -tulpn | grep 8080
  pgrep -af rogue-process.py

STEP 5 — KILL CONFLICTING PROCESS
  sudo kill -9 <PID>

STEP 6 — RESTART SERVICE
  sudo systemctl reset-failed payment-processor
  sudo systemctl restart payment-processor

STEP 7 — VERIFY
  systemctl is-active payment-processor
  curl -s -o /dev/null -w "%{http_code}" http://localhost:8080

STEP 8 — CLOSE INCIDENT
• Document root cause; update resolution time; close ticket

ESCALATION
L2 Support: _______________
L3 Support: _______________
On-call Manager: _______________
```

---

## Step 14 — Save Your Workbook

Save as `lab3_[yourname].xlsx`. Confirm all seven sheets are complete:

- Raw Metrics
- SLA Calculations
- MTTR MTBF
- Availability
- KPI Dashboard
- Postmortem
- Runbook

---

## Bonus Challenge (Optional)

Your CloudWatch data shows **15 minutes** of downtime. SLA target is **99.9%** availability (max **43 minutes** downtime per month).

**Did you meet SLA if this was the only incident?**

> Yes — 15 minutes is within the 43 minutes allowed for 99.9% monthly availability.

---

## Summary

| Concept | How you applied it |
|---------|-------------------|
| CloudWatch Agent | Installed and configured on EC2 |
| Custom metrics | ServiceHealth and ResponseTimeMs |
| CloudWatch dashboard | Lab3-SLA-Dashboard |
| CloudWatch alarms | Service down and high response time |
| SLA calculations | Compliance from real or sample data |
| MTTR / MTBF / Availability | Calculated in Excel |
| Blameless postmortem | 5 Whys and action items |
| Runbook | Step-by-step recovery SOP |
