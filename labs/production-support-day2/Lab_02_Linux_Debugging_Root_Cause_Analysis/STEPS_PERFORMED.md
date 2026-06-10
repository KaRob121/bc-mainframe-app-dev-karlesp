# Lab 2 — Steps Performed (Reference Execution)

**Lab:** Linux System Debugging and Root Cause Analysis (Mock Template Version)  
**Workbook created:** `instructor/lab2_solution.xlsx`  
**Executed:** 2026-06-10  
**Scenario:** FinTech PayCore — `payment-processor` service failure (port 8080 conflict)

This document records each lab step as performed to produce the solution workbook. Participants follow [instructions.md](instructions.md) and build their own file; this is a reference run.

---

## Step 1 – Create Lab 2 Excel Workbook

| Action | Result |
|--------|--------|
| Opened Excel workbook builder (openpyxl) | New workbook created |
| Saved as `lab2_linux_debugging_rca.xlsx` | Saved to `instructor/lab2_solution.xlsx` |

**Status:** ✅ Complete

---

## Step 2 – Create Investigation Log Sheet

| Action | Result |
|--------|--------|
| Created sheet **Investigation Log** | First/active sheet |
| Added headers: Step, Command / Action, Output Observed, What It Tells You, Status | Row 1 populated |
| Applied header styling (green fill, white bold text) | Headers formatted |

**Status:** ✅ Complete

---

## Step 3 – Add Linux Command Reference Sheet

| Action | Result |
|--------|--------|
| Created sheet **Linux Commands** | Second sheet |
| Added 8 commands with Purpose and Example columns | All reference rows entered |

**Commands added:**

1. `systemctl status <service>`
2. `systemctl start <service>`
3. `systemctl restart <service>`
4. `journalctl -u <service> -n 50`
5. `journalctl -u <service> -f`
6. `ss -tulpn`
7. `ps aux | grep <name>`
8. `kill -9 <PID>`

**Status:** ✅ Complete

---

## Step 4 – Simulate Initial Investigation

| Step | Command / Action | Output Observed | What It Tells You | Status |
|------|------------------|-----------------|-------------------|--------|
| 1 | `systemctl status payment-processor` | `inactive (dead) / failed` | Service is not running | Completed |
| 2 | `systemctl restart payment-processor` | `Failed to start: Address already in use` | Port conflict – something else is using the port | Completed |
| 3 | `journalctl -u payment-processor -n 50` | `bind failed: port 8080 already in use` | Confirms port 8080 is occupied | Completed |

**Finding:** Service is down; restart fails due to port 8080 conflict.

**Status:** ✅ Complete

---

## Step 5 – Simulate Identifying the Rogue Process

| Step | Command / Action | Output Observed | What It Tells You | Status |
|------|------------------|-----------------|-------------------|--------|
| 4 | `ss -tulpn \| grep 8080` | `LISTEN ... users:(("old-process",PID=9876))` | Process ID 9876 is using port 8080 | Completed |
| 5 | `ps aux \| grep 9876` | `old-process /opt/legacy/app` | An old legacy application is still running | Completed |

**Finding:** Legacy `old-process` (PID 9876) was never stopped after migration.

**Status:** ✅ Complete

---

## Step 6 – Simulate Fixing the Issue

| Step | Command / Action | Output Observed | What It Tells You | Status |
|------|------------------|-----------------|-------------------|--------|
| 6 | `kill -9 9876` | Process terminated | Rogue process removed from port 8080 | Completed |
| 7 | `systemctl restart payment-processor` | `Started payment-processor.service` | Service started successfully | Completed |
| 8 | `systemctl status payment-processor` | `active (running)` | Service is healthy | Completed |
| 9 | Test transaction | `Success` | Service is working | Completed |

**Finding:** Port freed; service restored; transaction test passed.

**Status:** ✅ Complete

---

## Step 7 – Root Cause Analysis (5 Whys)

Created sheet **5 Whys Analysis**:

| Why # | Question | Answer |
|-------|----------|--------|
| 1 | Why did the payment-processor fail to start? | Because port 8080 was already in use. |
| 2 | Why was port 8080 already in use? | Because an old legacy process was still running. |
| 3 | Why was the old legacy process still running? | Because the migration script did not stop it. |
| 4 | Why did the migration script not stop it? | Because the stop command was missing from the runbook. |
| 5 | Why was the stop command missing? | Because the runbook was never reviewed after the migration. |

**Root Cause:** Incomplete runbook and missing validation step in the migration process.

**Status:** ✅ Complete

---

## Step 8 – Write RCA Report

Created sheet **RCA Report** with full report text:

| Field | Value |
|-------|-------|
| Incident ID | INC-002 |
| Date | 2026-06-10 |
| Service Affected | payment-processor |
| Severity | P1 (Critical) |
| Total downtime | 15 minutes |

**Key sections documented:**
- Incident summary (port conflict on 8080)
- Timeline (09:00 – 09:15)
- Root cause (legacy process + incomplete runbook)
- Corrective actions (immediate, short-term, long-term)
- Prevention measures

**Status:** ✅ Complete

---

## Step 9 – Permanent Fix and Prevention

Created sheet **Permanent Fix**:

| Fix Type | Action | Owner | Due Date |
|----------|--------|-------|----------|
| Runbook Update | Add step to stop legacy process before starting new service | L2 Team | 2026-06-11 |
| Automation Script | Add port conflict check in deployment pipeline | DevOps | 2026-06-15 |
| Monitoring Alert | Alert if port 8080 is occupied before deployment | Monitoring Team | 2026-06-12 |
| Runbook Review | Quarterly review of all production runbooks | L2 Lead | Ongoing |

**Status:** ✅ Complete

---

## Step 10 – Final Checklist

| # | Sheet Name | Status |
|---|------------|--------|
| 1 | Investigation Log | ✅ 9 rows |
| 2 | Linux Commands | ✅ 8 commands |
| 3 | 5 Whys Analysis | ✅ 5 whys + root cause |
| 4 | RCA Report | ✅ Complete |
| 5 | Permanent Fix | ✅ 4 actions |

**Workbook saved:** `instructor/lab2_solution.xlsx`  
**Starter template saved:** `template/lab2_starter.xlsx` (Investigation Log headers only)

**Status:** ✅ Lab 2 complete

---

## Bonus Challenge (Reference Answer)

**Question:** The same port conflict happens again one week later on a different server. What does this tell you?

**Answer:** The permanent fix was not applied to all servers. The RCA should have included an inventory check to identify all servers running the legacy process — fixing one instance without addressing the systemic issue.

---

## Artifacts Produced

| File | Purpose |
|------|---------|
| `instructor/lab2_solution.xlsx` | Complete solution workbook (all 5 sheets) |
| `template/lab2_starter.xlsx` | Headers-only Investigation Log starter |
| `instructions.md` | Participant lab steps |
| `instructor/answer_key.md` | Instructor expected answers |
| `STEPS_PERFORMED.md` | This execution log |
