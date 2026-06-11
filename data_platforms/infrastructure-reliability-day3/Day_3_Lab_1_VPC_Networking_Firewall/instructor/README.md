# Lab 1 — Instructor Package

**Estimated setup time:** 20–30 minutes (first time) · 10 minutes (repeat classes)  
**Region:** US East (N. Virginia) — **`us-east-1`**

---

## Before class

1. Confirm students have AWS accounts with permissions to create VPC, EC2 (EIP), and Network Firewall resources.
2. Follow **[AWS_LAB1_SETUP.md](AWS_LAB1_SETUP.md)** — run the validation script once yourself.
3. Walk through **[instructions.md](../instructions.md)** Steps 1–8 in the console to confirm UI paths match (AWS console labels change occasionally).
4. Tell students:
   - Region must be **`us-east-1`**
   - Exact resource names from the guide
   - Their public IP for SSH NACL/SG rules (`x.x.x.x/32`)
   - Tear down NAT and Firewall within 1 hour to limit cost (~$0.45)
   - **Security groups:** do **not** search `Lab1-VPC` — search **`Web-SG`** / **`Firewall-SG`** instead
5. Point students to reference screenshots in **[screenshots/reference/](../screenshots/reference/)** when the console UI is unclear.

---

## Materials

| File | Purpose |
|------|---------|
| [AWS_LAB1_SETUP.md](AWS_LAB1_SETUP.md) | Pre-lab IAM, validation script, teardown order |
| [answer_key.md](answer_key.md) | Expected values per step for grading |
| [CONSOLE_UI_GUIDE.md](CONSOLE_UI_GUIDE.md) | UI pitfalls (Security groups filter, main RT, default VPC) |
| [../instructions.md](../instructions.md) | Student guide — Steps 1–9 |
| [../setup/test_vpc_lab1.py](../setup/test_vpc_lab1.py) | Deploy, validate, or tear down lab resources |
| [../setup/requirements.txt](../setup/requirements.txt) | Python dependencies for validation script |

---

## Quick validation (instructor)

From the lab folder:

```powershell
cd Day_3_Lab_1_VPC_Networking_Firewall
pip install -r setup/requirements.txt
python setup/test_vpc_lab1.py --validate-only
```

After you build the lab manually (or with `--deploy`), all checks should print `PASS`.

---

## Pacing guide (50–60 min class block)

| Time | Activity |
|------|----------|
| 0–5 min | Region check, IP lookup, architecture overview |
| 5–15 min | Steps 1–3 (VPC, subnets, IGW) |
| 15–25 min | Step 4 (route tables) |
| 25–35 min | Step 5 (NAT — wait for Available) |
| 35–45 min | Steps 6–7 (NACL, security groups) |
| 45–55 min | Step 8 (Network Firewall — may finish provisioning after class) |
| 55–60 min | Step 9 review, deliverables checklist, tear-down reminder |

> **Tip:** Start Step 8 (firewall) before Step 6 if the class is slow — firewall provisioning takes 5–10 minutes and can run while students configure NACLs.

---

## Common student mistakes

| Mistake | Fix |
|---------|-----|
| **Searches `Lab1-VPC` on Security groups page** | Expected empty result — search **`Web-SG`** / **`Firewall-SG`** or match VPC ID column |
| Thinks lab failed because default VPC exists | Default VPC `172.31.0.0/16` is normal; lab uses **`Lab1-VPC`** `10.0.0.0/16` |
| Confused by **four** route tables | Fourth row is **Main** route table — required; lab uses Public/Private/Firewall-RT |
| Wrong region (e.g. us-west-2) | AZ names won't match; switch to us-east-1 and recreate |
| NAT in private subnet | NAT must be in `Public-Subnet-A` |
| Forgot Public-RT IGW route | Public subnet won't reach internet; add 0.0.0.0/0 → IGW |
| SSH rule uses bare IP | Must be CIDR: `203.0.113.45/32` |
| NACL deny rule number too low | DENY must be rule 200, after ALLOW rules 100–130 |
| Deletes VPC before NAT/Firewall | Delete firewall and NAT first, release EIP, then VPC |

---

## Reference screenshots (instructor demo)

Validated UI captures live in **[screenshots/reference/](../screenshots/reference/)**. Use when live-demoing or when a student shares a confusing screen:

| Step | Reference file | Key UI element |
|------|----------------|----------------|
| 1 | `Step_01_VPC_Created.png` | Lab1-VPC in Your VPCs list |
| 2 | `Step_02_Subnets_Created.png` | Filter `Lab1-VPC` → 3 subnets |
| 3 | `Step_03_IGW_Attached.png` | Lab1-IGW Attached to Lab1-VPC |
| 4 | `Step_04_Route_Tables.png` | 3 custom RTs + Main row |
| 5 | `Step_05_NAT_GatewaypartA/B.png` | NAT Available + Private-RT NAT route |
| 6 | `Step_06_NACL_Rules.png` + `part2` | Inbound rules + Private-Subnet-B association |
| 7 | `Step_07_Security_Groupsparta/b.png` | Web-SG and Firewall-SG inbound (search by name!) |
| 8 | `Step_08_Network_Firewall.png` | Lab1-Firewall-Policy + Allow-Web-Traffic |
| 9 | `Step_09_Firewall_Endpoint.png` | Firewall-Subnet-A details |
| — | `Lab 1.png` | VPC Resource map overview |

---

## Student guide

[../instructions.md](../instructions.md) — Steps 1–9 (AWS Console)
