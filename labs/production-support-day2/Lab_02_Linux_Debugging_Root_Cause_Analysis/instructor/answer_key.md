# Lab 2: Linux System Debugging and Root Cause Analysis — Instructor Answer Key

**Solution workbook (mock):** [lab2_solution.xlsx](lab2_solution.xlsx)  
**Live AWS setup:** [AWS_EC2_SETUP.md](AWS_EC2_SETUP.md)  
**Live student guide:** [instructions_live.md](../instructions_live.md)

---

## Investigation Log — Expected Rows (Steps 4–6)

| Step | Command / Action | Output Observed | What It Tells You |
|------|------------------|-----------------|-------------------|
| 1 | `systemctl status payment-processor` | `inactive (dead) / failed` | Service is not running |
| 2 | `systemctl restart payment-processor` | `Failed to start: Address already in use` | Port conflict |
| 3 | `journalctl -u payment-processor -n 50` | `bind failed: port 8080 already in use` | Port 8080 occupied |
| 4 | `ss -tulpn \| grep 8080` | PID 9876 on port 8080 | Rogue process identified |
| 5 | `ps aux \| grep 9876` | `old-process /opt/legacy/app` | Legacy app still running |
| 6 | `kill -9 9876` | Process terminated | Port freed |
| 7 | `systemctl restart payment-processor` | `Started payment-processor.service` | Service started |
| 8 | `systemctl status payment-processor` | `active (running)` | Service healthy |
| 9 | Test transaction | `Success` | Service verified |

---

## 5 Whys — Expected Root Cause

**Root Cause:** Incomplete runbook and missing validation step in the migration process.

---

## RCA Timeline — Key Events

| Time | Event |
|------|-------|
| 09:00 | Service found in failed state |
| 09:05 | Logs showed port 8080 already in use |
| 09:10 | Rogue process identified (PID 9876) |
| 09:12 | Process killed, service restarted |
| 09:15 | Service confirmed working |
| **Total downtime** | **15 minutes** |

---

## Bonus Challenge Answer

**Scenario:** The same port conflict happens again one week later on a different server.

**Answer:**

> The permanent fix was not applied to all servers. The RCA should have included an inventory check to identify all servers running the legacy process. This is a common gap — fixing one instance but not addressing the systemic issue.

---

## Common Mistakes to Watch For

| Mistake | Correction |
|---------|------------|
| Stopping at port conflict without finding the process | Must use `ss -tulpn` and `ps` to identify the rogue process |
| Skipping 5 Whys and only documenting the immediate fix | Root cause is process/runbook gap, not just "port in use" |
| RCA missing timeline or corrective actions | All three sections required for a complete report |
| Permanent fix only lists immediate runbook change | Include automation, monitoring, and ongoing review |

---

## Instructor Notes

### Setup Requirements

- Ensure participants have Excel or Google Sheets access
- Estimated time: 25–30 minutes
- This is a **mock template lab** — no live Linux server required

### Delivery Tips

- Emphasize the difference between **symptom** (port conflict) and **root cause** (incomplete runbook)
- Walk through Investigation Log rows 1–3 before participants continue independently
- Use the bonus challenge to discuss systemic vs. one-off fixes
