# Lab 2 — AWS EC2 Live Broken System Setup (Instructor Guide)

Launch an **Amazon Linux 2023 EC2 instance** with a pre-built broken `payment-processor` service. Students SSH in, debug with `systemctl`, `journalctl`, and `ss`, then fix the port conflict.

**Estimated instructor setup time:** ~10 minutes  
**Cost:** `t2.micro` is free tier eligible (~$0.0116/hour beyond free tier)

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    AWS Cloud                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              EC2 Instance (Amazon Linux 2023)            │   │
│  │                                                          │   │
│  │  ┌─────────────────────────────────────────────────┐    │   │
│  │  │  Broken Service: payment-processor.service      │    │   │
│  │  │  • Fails to start                               │    │   │
│  │  │  • Port 8080 blocked by rogue process           │    │   │
│  │  │  • Logs show "address already in use"           │    │   │
│  │  └─────────────────────────────────────────────────┘    │   │
│  │                                                          │   │
│  │  Students: ssh -i key.pem ec2-user@<public-ip>          │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Launch EC2 Instance

1. Go to **EC2 Dashboard** → **Instances** → **Launch instance**
2. Configure:

| Field | Value |
|-------|-------|
| Name | `Lab2-Broken-System` |
| AMI | **Amazon Linux 2023 AMI** (free tier eligible) |
| Instance type | `t2.micro` (free tier) |
| Key pair | Create or select existing (required for SSH) |
| Network settings | Allow SSH from your IP (or `0.0.0.0/0` for classroom training) |

3. Click **Launch instance**
4. Wait for instance state **Running** (~2 minutes)

### Optional: Pre-broken instance with User Data

Paste the contents of [setup/user_data.sh](../setup/user_data.sh) into **Advanced details** → **User data** at launch. Skip Step 3 if using User Data (wait ~2 minutes after boot, then verify in Step 4).

---

## Step 2: SSH into the Instance

```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<public-ip-address>
```

Replace `your-key.pem` and `<public-ip-address>` with your key file and instance public IP.

---

## Step 3: Create the Broken System

If you did **not** use User Data, run the setup script on the instance:

```bash
curl -sO https://raw.githubusercontent.com/innovationinsoftware/bc-mainframe-app-dev/main/labs/production-support-day2/Lab_02_Linux_Debugging_Root_Cause_Analysis/setup/create_broken_system.sh
# Or copy setup/create_broken_system.sh via scp, then:
chmod +x create_broken_system.sh
./create_broken_system.sh
```

**Local copy:** [setup/create_broken_system.sh](../setup/create_broken_system.sh)

---

## Step 4: Verify the System is Broken

```bash
systemctl status payment-processor
ss -tulpn | grep 8080
sudo journalctl -u payment-processor -n 20
```

**Expected:**
- `systemctl status` → `inactive (dead)` or `failed`
- `ss -tulpn` → `python3` listening on `:8080`
- `journalctl` → `Address already in use` or similar bind error

---

## Step 5: Student Instructions

Point students to **[instructions_live.md](../instructions_live.md)** for live SSH debugging steps.

After students complete the live fix, they can document findings in the Excel mock lab ([instructions.md](../instructions.md)) or in their RCA workbook.

---

## Step 6: Reset Between Sessions

Run on the instance between students:

```bash
chmod +x reset_lab2.sh
./reset_lab2.sh
```

**Local copy:** [setup/reset_lab2.sh](../setup/reset_lab2.sh)

---

## Step 7: Terraform (Optional)

For repeatable environments:

```bash
cd setup/terraform
terraform init
terraform apply -var="key_name=your-key-pair-name"
```

Outputs the instance public IP for SSH.

---

## Summary

| Step | Action | Time |
|------|--------|------|
| 1 | Launch EC2 (Amazon Linux 2023, t2.micro) | 2 min |
| 2 | SSH into instance | 1 min |
| 3 | Run broken system script (or use User Data) | 2 min |
| 4 | Verify system is broken | 1 min |
| 5 | Students debug and fix | 15–20 min |
| 6 | Reset for next session | 1 min |

---

## Setup Scripts

| Script | Purpose |
|--------|---------|
| [setup/create_broken_system.sh](../setup/create_broken_system.sh) | Manual broken state after SSH |
| [setup/user_data.sh](../setup/user_data.sh) | EC2 User Data — auto-broken at launch |
| [setup/reset_lab2.sh](../setup/reset_lab2.sh) | Reset between students |
| [setup/terraform/main.tf](../setup/terraform/main.tf) | Optional IaC deployment |
