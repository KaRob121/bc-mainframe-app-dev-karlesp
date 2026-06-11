# Lab 3: SLA Compliance, Operational Reporting & Blameless Postmortem

**Estimated time:** 45–50 minutes  
**Tools needed:** AWS Console, SSH terminal, Microsoft Excel or Google Sheets

**Prerequisite:** Lab 2 EC2 instance (`payment-processor` service) is running and fixed.

**AWS region:** Canada (Central) — `ca-central-1`

> **Recommended:** Copy [template/lab3_starter.xlsx](template/lab3_starter.xlsx) to `lab3_[yourname].xlsx` before Step 8. The starter includes all seven sheets with labels and fill-in sections.

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

<img src="diagrams/lab3-architecture.svg" alt="Lab 3 architecture: EC2 metrics to CloudWatch to Excel for SLA reporting" width="560"/>

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

## Step 8 — Open Your Excel Workbook

1. Copy [template/lab3_starter.xlsx](template/lab3_starter.xlsx) to `lab3_[yourname].xlsx`.
2. Open the file in Excel or Google Sheets.
3. Confirm these seven sheets exist:

| Sheet | What you will complete |
|-------|------------------------|
| Raw Metrics | Paste CloudWatch export (Step 7) |
| SLA Calculations | Metrics table + compliance summary |
| MTTR MTBF | Reliability formulas and values |
| Availability | Uptime and 99.9% SLA check |
| KPI Dashboard | Weekly summary |
| Postmortem | Blameless incident review |
| Runbook | Recovery SOP |

---

## Step 9 — Calculate SLA Metrics

On the **SLA Calculations** sheet, enter your CloudWatch data in the metrics table (or use this sample if metrics are sparse):

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

**Fill in the summary section** at the bottom of the sheet:

- **Downtime intervals** — count rows where ServiceHealth = 0
- **Total downtime (minutes)** — intervals × 5
- **Response SLA compliance %** — `(readings ≤ 150 ms) ÷ (readings with data) × 100`
- **Resolution SLA compliance %** — estimate from incident handling (sample: 92%)

---

## Step 10 — Calculate MTTR, MTBF, and Availability

On the **MTTR MTBF** sheet, enter values in the **Value** column using these formulas:

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

Copy **Availability %** to the **Availability** sheet. Check whether the incident meets the 99.9% monthly SLA (max 43 minutes downtime).

---

## Step 11 — Complete KPI Dashboard

On the **KPI Dashboard** sheet, fill in every blank using your calculations from Steps 9–10:

- Service health (availability, downtime, incident count)
- SLA compliance (response, resolution, overall)
- Reliability (MTTR, MTBF)
- Top alerts (from CloudWatch alarms)
- Three action items for follow-up

---

## Step 12 — Write Blameless Postmortem

On the **Postmortem** sheet, complete every section using your CloudWatch timeline and Lab 2 root cause:

- Incident details (INC-AWS-001, P1, SLA met or not)
- What happened and when (start, end, duration)
- 5 Whys down to root cause
- What went well / what went wrong
- Action items with owner and due date
- Lessons learned

---

## Step 13 — Complete Runbook (SOP)

On the **Runbook** sheet, review the eight recovery steps (acknowledge → verify → close). Confirm commands match your Lab 2 fix flow:

- `sudo ss -tulpn | grep 8080` and `pgrep -af rogue-process.py`
- `sudo kill -9 <PID>` (not `pkill -f`)
- `sudo systemctl reset-failed` before restart

Add escalation contacts at the bottom.

---

## Step 14 — Save Your Workbook

Save `lab3_[yourname].xlsx`. Confirm all seven sheets are complete:

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
