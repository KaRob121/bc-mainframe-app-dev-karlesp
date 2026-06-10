# Lab 2: Linux System Debugging and Root Cause Analysis (Mock Template Version)

**Estimated time:** 25–30 minutes

**Tools needed:** Microsoft Excel or Google Sheets

> **Optional:** Copy [template/lab2_starter.xlsx](template/lab2_starter.xlsx) instead of starting from a blank workbook in Step 1.

---

## Lab Objectives

By the end of this lab, you will be able to:
- Diagnose a failing production service using logs and system commands
- Identify port conflicts and rogue processes
- Apply permanent fixes to prevent recurrence
- Perform root cause analysis using the 5 Whys technique
- Document findings in an RCA report

---

## Reference Materials (Provided Below)

| Document | Location |
|----------|----------|
| Linux Command Reference | Step 3 |
| 5 Whys RCA Template | Step 7 |
| RCA Report Template | Step 8 |

---

## Scenario Background

You are the **L2 support engineer** for `FinTech PayCore`.

**The Problem:**
The `payment-processor` service keeps failing. Users report that transactions are intermittent. The service was working fine yesterday.

**Your mission:**
Diagnose the issue, fix it permanently, and write a root cause analysis report.

---

## Step 1 – Create Your Lab 2 Excel Workbook

**Action:**

1. Open **Microsoft Excel** or **Google Sheets**
2. Create a **new blank workbook**
3. Save it as: `lab2_linux_debugging_rca.xlsx`

---

## Step 2 – Create Investigation Log Sheet

**Action:**

Create a sheet named **Investigation Log**

Add these column headers in Row 1:

| A | B | C | D | E |
|---|---|---|---|---|
| Step | Command / Action | Output Observed | What It Tells You | Status |

---

## Step 3 – Add Linux Command Reference Sheet

**Action:**

Create a **second sheet** named **Linux Commands**

Copy this table into the sheet:

| Command | Purpose | Example |
|---------|---------|---------|
| `systemctl status <service>` | Check if service is running | `systemctl status payment-processor` |
| `systemctl start <service>` | Start a stopped service | `systemctl start payment-processor` |
| `systemctl restart <service>` | Restart a service | `systemctl restart payment-processor` |
| `journalctl -u <service> -n 50` | View last 50 lines of service logs | `journalctl -u payment-processor -n 50` |
| `journalctl -u <service> -f` | Follow live logs | `journalctl -u payment-processor -f` |
| `ss -tulpn` | List all ports and running processes | `ss -tulpn \| grep 8080` |
| `ps aux \| grep <name>` | Find process by name | `ps aux \| grep java` |
| `kill -9 <PID>` | Force kill a process | `kill -9 12345` |

---

## Step 4 – Simulate Initial Investigation

**Scenario:** You run the first diagnostic commands.

**Action:**

In the **Investigation Log** sheet, add these rows:

| A | B | C | D | E |
|---|---|---|---|---|
| 1 | `systemctl status payment-processor` | `inactive (dead) / failed` | Service is not running | Completed |
| 2 | `systemctl restart payment-processor` | `Failed to start: Address already in use` | Port conflict – something else is using the port | Completed |
| 3 | `journalctl -u payment-processor -n 50` | `bind failed: port 8080 already in use` | Confirms port 8080 is occupied | Completed |

---

## Step 5 – Simulate Identifying the Rogue Process

**Scenario:** You need to find what is using port 8080.

**Action:**

Add these rows to **Investigation Log**:

| A | B | C | D | E |
|---|---|---|---|---|
| 4 | `ss -tulpn \| grep 8080` | `LISTEN 0 50 *:8080 *:* users:(("old-process",PID=9876))` | Process ID 9876 is using port 8080 | Completed |
| 5 | `ps aux \| grep 9876` | `old-process /opt/legacy/app` | An old legacy application is still running | Completed |

**What this means:** A legacy process was never stopped after a migration. It is blocking the new payment-processor service.

---

## Step 6 – Simulate Fixing the Issue

**Scenario:** You stop the rogue process and restart the service.

**Action:**

Add these rows to **Investigation Log**:

| A | B | C | D | E |
|---|---|---|---|---|
| 6 | `kill -9 9876` | Process terminated | Rogue process removed from port 8080 | Completed |
| 7 | `systemctl restart payment-processor` | `Started payment-processor.service` | Service started successfully | Completed |
| 8 | `systemctl status payment-processor` | `active (running)` | Service is healthy | Completed |
| 9 | Test transaction | `Success` | Service is working | Completed |

---

## Step 7 – Root Cause Analysis (5 Whys)

**Scenario:** You must find the **root cause** – not just the immediate fix.

**Action:**

Create a **third sheet** named **5 Whys Analysis**

Copy this template and fill it in:

| Why # | Question | Answer |
|-------|----------|--------|
| 1 | Why did the payment-processor fail to start? | Because port 8080 was already in use. |
| 2 | Why was port 8080 already in use? | Because an old legacy process was still running. |
| 3 | Why was the old legacy process still running? | Because the migration script did not stop it. |
| 4 | Why did the migration script not stop it? | Because the stop command was missing from the runbook. |
| 5 | Why was the stop command missing? | Because the runbook was never reviewed after the migration. |

**Root Cause:** Incomplete runbook and missing validation step in the migration process.

---

## Step 8 – Write RCA Report

**Action:**

Create a **fourth sheet** named **RCA Report**

Copy this template and fill it in:

```
ROOT CAUSE ANALYSIS REPORT

Incident ID: INC-002
Date: 2026-06-10
Service Affected: payment-processor
Severity: P1 (Critical)

INCIDENT SUMMARY:
The payment-processor service failed to start due to a port conflict on 8080.

TIMELINE:
- 09:00 – Service found in failed state
- 09:05 – Logs showed port 8080 already in use
- 09:10 – Rogue process identified (PID 9876, old-process)
- 09:12 – Process killed, service restarted
- 09:15 – Service confirmed working
- Total downtime: 15 minutes

ROOT CAUSE:
A legacy process was left running after a migration. The runbook did not include a step to stop the old process, and no validation was performed to confirm the port was free.

CORRECTIVE ACTIONS:
1. [Immediate] Update runbook to include stopping legacy process
2. [Short-term] Add port availability check to deployment script
3. [Long-term] Implement automated service health validation after migrations

PREVENTION:
- All runbooks will be reviewed monthly
- Migration checklists will include "verify no rogue processes"
```

---

## Step 9 – Permanent Fix and Prevention

**Action:**

Create a **fifth sheet** named **Permanent Fix**

Add this table:

| Fix Type | Action | Owner | Due Date |
|----------|--------|-------|----------|
| Runbook Update | Add step to stop legacy process before starting new service | L2 Team | 2026-06-11 |
| Automation Script | Add port conflict check in deployment pipeline | DevOps | 2026-06-15 |
| Monitoring Alert | Alert if port 8080 is occupied before deployment | Monitoring Team | 2026-06-12 |
| Runbook Review | Quarterly review of all production runbooks | L2 Lead | Ongoing |

---

## Step 10 – Final Checklist

Verify your Excel file contains:

| # | Sheet Name | Content |
|---|------------|---------|
| 1 | Investigation Log | 9 investigation rows |
| 2 | Linux Commands | 8 command references |
| 3 | 5 Whys Analysis | 5 whys + root cause |
| 4 | RCA Report | Complete report text |
| 5 | Permanent Fix | 4 preventive actions |

**Final Action:** Save your Excel file as `lab2_[yourname].xlsx`

---

## Bonus Challenge (Optional)

**Scenario:** The same port conflict happens again one week later on a different server.

**Question:** What does this tell you about your corrective actions?

Write your answer in a few sentences. Discuss with your instructor or group after completing the lab.

---

## Summary – What You Learned

| Concept | How You Applied It |
|---------|---------------------|
| Systemd service management | Checked status, restarted service |
| Log analysis | Used journalctl to find errors |
| Port conflict diagnosis | Used ss -tulpn to find rogue process |
| Process management | Used kill to terminate process |
| 5 Whys RCA | Traced symptom → direct cause → root cause |
| RCA Report | Documented timeline, root cause, corrective actions |
| Permanent Fix | Planned preventive measures |

---

## Troubleshooting Tips

| Problem | Solution |
|---------|----------|
| Text gets cut off in a cell | Double-click between column letters to auto-fit width |
| RCA Report hard to read | Merge cells or widen column A; enable Wrap Text |
| Sheet tabs not visible | Look at bottom-left corner, click the arrows or + sign |
| Using Google Sheets | Same steps apply; paste tables row by row |

---

## Ready to Begin?

Open Excel or Google Sheets and start with **Step 1**.

Follow the steps sequentially from Step 1 through Step 10.
