# Lab 2 — AWS EC2 Setup (Instructor)

**Time:** ~10 minutes | **Instance:** Amazon Linux 2023, `t2.micro`

---

## 1. Launch instance

| Field | Value |
|-------|-------|
| Name | `Lab2-Broken-System` |
| AMI | Amazon Linux 2023 |
| Type | `t2.micro` |
| Key pair | Required for SSH |
| Security group | SSH (port 22) from your IP |

**User Data (recommended):** Paste [setup/user_data.sh](../setup/user_data.sh) under **Advanced details → User data**. Wait 2 minutes after boot.

**Manual setup:** SSH in and run [setup/create_broken_system.sh](../setup/create_broken_system.sh).

---

## 2. Verify broken state

```bash
systemctl status payment-processor          # failed or inactive
sudo ss -tulpn | grep 8080                  # python3 on :8080
pgrep -af rogue-process.py                  # rogue PID
sudo journalctl -u payment-processor -n 20  # Address already in use
```

---

## 3. Give students

- Public IP
- `.pem` key file
- [instructions_live.md](../instructions_live.md)

---

## 4. Reset between students

```bash
bash setup/reset_lab2.sh
```

Or copy [setup/reset_lab2.sh](../setup/reset_lab2.sh) to the instance.

---

## 5. Test from your machine

```bash
python setup/test_aws_lab2.py --terminate
```

Creates instance, verifies broken + fix flow, terminates. Requires AWS credentials in `us-west-1` (or edit script region).

---

## Scripts

| Script | Use |
|--------|-----|
| [user_data.sh](../setup/user_data.sh) | Auto-break at launch |
| [create_broken_system.sh](../setup/create_broken_system.sh) | Manual break after SSH |
| [reset_lab2.sh](../setup/reset_lab2.sh) | Reset for next student |
| [test_aws_lab2.py](../setup/test_aws_lab2.py) | End-to-end test |
