# Lab 2: Linux System Debugging — Live AWS Version

**Estimated time:** 20–25 minutes  
**Tools needed:** SSH client, EC2 key pair, instructor-provided instance IP

**Prerequisite:** Your instructor has launched a broken Amazon Linux 2023 EC2 instance. See [instructor/AWS_EC2_SETUP.md](instructor/AWS_EC2_SETUP.md).

---

## Scenario

You are the **L2 support engineer** for `FinTech PayCore`. The `payment-processor` service is failing. Users report intermittent transactions.

**Your mission:** SSH into the server, diagnose the failure, fix it, and verify the service is healthy.

---

## Step 1 – Connect to the Instance

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<public-ip-address>
```

Replace with your key file and the instance IP provided by your instructor.

---

## Step 2 – Check Service Status

```bash
systemctl status payment-processor
```

**What to look for:** Service is `inactive`, `failed`, or not running.

---

## Step 3 – Check Service Logs

```bash
sudo journalctl -u payment-processor -n 50
```

**What to look for:** Errors mentioning port 8080 or "Address already in use".

---

## Step 4 – Find What Is Using Port 8080

```bash
ss -tulpn | grep 8080
```

**What to look for:** A `python3` process (rogue legacy process) holding port 8080. Note the **PID**.

---

## Step 5 – Identify the Rogue Process

```bash
ps aux | grep <PID>
```

Replace `<PID>` with the process ID from Step 4.

**What this means:** A legacy process was never stopped after a migration and is blocking the new service.

---

## Step 6 – Stop the Rogue Process

```bash
sudo kill -9 <PID>
```

Verify port 8080 is free:

```bash
ss -tulpn | grep 8080
```

(No output means the port is free.)

---

## Step 7 – Restart the Service

```bash
sudo systemctl restart payment-processor
```

---

## Step 8 – Verify the Fix

```bash
systemctl status payment-processor
systemctl is-active payment-processor
```

**Expected:** `active (running)`

Optional smoke test:

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080
```

**Expected:** `200`

---

## Step 9 – Document Your Investigation (Optional)

Record your commands and findings in the Excel mock lab ([instructions.md](instructions.md)) or your investigation log:

| Step | Command | Finding |
|------|---------|---------|
| 1 | `systemctl status payment-processor` | Service failed |
| 2 | `journalctl -u payment-processor -n 50` | Port 8080 in use |
| 3 | `ss -tulpn \| grep 8080` | Rogue PID identified |
| 4 | `kill -9 <PID>` | Port freed |
| 5 | `systemctl restart payment-processor` | Service restored |

---

## Step 10 – Root Cause Analysis (Discussion)

Answer these questions (discuss with your group or instructor):

1. **Why** did `payment-processor` fail to start?
2. **Why** was port 8080 already in use?
3. What **permanent fix** would prevent this after future migrations?

See the 5 Whys template in [instructions.md](instructions.md) Step 7 for the full RCA exercise.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| SSH connection refused | Check security group allows port 22 from your IP |
| Permission denied (publickey) | Verify key file: `chmod 400 your-key.pem` |
| `kill` does not free port 8080 | Run `sudo pkill -f rogue-process.py`, then recheck with `ss` |
| Service still fails after kill | Run `sudo journalctl -u payment-processor -n 20` for new errors |

---

## Ready to Begin?

SSH into your instance and start with **Step 2** (service status).
