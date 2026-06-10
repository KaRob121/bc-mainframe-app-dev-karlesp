# Lab 2: Linux System Debugging and Root Cause Analysis

**Estimated time:** 25–30 minutes

---

## Choose your lab mode

| Mode | Tools | Guide |
|------|-------|-------|
| **Mock (Excel)** | Microsoft Excel or Google Sheets | [instructions.md](instructions.md) |
| **Live (AWS EC2)** | SSH + Amazon Linux 2023 instance | [instructions_live.md](instructions_live.md) |

Both modes cover the same scenario: `payment-processor` fails due to a port 8080 conflict with a rogue legacy process.

---

## Mock version — Start here

1. Open **[instructions.md](instructions.md)** and follow Steps 1–10.
2. Create your own workbook, **or** copy [template/lab2_starter.xlsx](template/lab2_starter.xlsx).
3. Save as `lab2_[yourname].xlsx`.

| Item | Location |
|------|----------|
| Lab steps | [instructions.md](instructions.md) |
| Starter template | [template/lab2_starter.xlsx](template/lab2_starter.xlsx) |
| Reference execution | [STEPS_PERFORMED.md](STEPS_PERFORMED.md) |

---

## Live AWS version — Start here

1. Your instructor provides EC2 IP and key pair (see [instructor/AWS_EC2_SETUP.md](instructor/AWS_EC2_SETUP.md)).
2. Open **[instructions_live.md](instructions_live.md)** and SSH into the broken instance.
3. Debug, fix, and verify `payment-processor` is running.

---

## Instructor materials

| Item | Location |
|------|----------|
| Answer key | [instructor/answer_key.md](instructor/answer_key.md) |
| Solution workbook (mock) | [instructor/lab2_solution.xlsx](instructor/lab2_solution.xlsx) |
| AWS EC2 setup guide | [instructor/AWS_EC2_SETUP.md](instructor/AWS_EC2_SETUP.md) |
| Broken system scripts | [setup/](setup/) |
