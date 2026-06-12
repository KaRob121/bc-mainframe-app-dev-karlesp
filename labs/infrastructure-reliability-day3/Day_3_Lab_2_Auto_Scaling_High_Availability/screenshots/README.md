# Lab 2 screenshots

## Region (every screenshot)

| Item | Required value |
|------|----------------|
| **AWS Region** | **US East (N. Virginia)** |
| **Region code** | **`us-east-1`** |
| **Check before each screenshot** | Top-right corner of AWS Console shows **N. Virginia** or **`us-east-1`** |

Wrong region = wrong AZ names and missing resources. **Always show the region selector in console screenshots.**

Step 9 and Step 12 browser screenshots do not need the AWS region bar — use the **ALB DNS name** in the address bar instead.

---

## Screenshot checklist by step

| Step | Save as | Console / tool | What to verify before you capture |
|------|---------|----------------|-----------------------------------|
| 1 | `Step_01_VPC_Subnets_Verified.png` | **VPC** → **Subnets** | Filter `Lab1-VPC`. See `Public-Subnet-A` + `Public-Subnet-C` (different AZs) and `Private-Subnet-B` + `Private-Subnet-C` (different AZs). |
| 2 | `Step_02_Launch_Template.png` | **EC2** → **Launch Templates** | `WebServer-LT`, version **1**, Auto Scaling guidance **on**, `Web-SG` selected. |
| 3 | `Step_03_Target_Group.png` | **EC2** → **Target Groups** → `ASG-TG` | HTTP:80, health path `/`, success code 200, VPC = `Lab1-VPC`. |
| 4 | `Step_04_ALB_Provisioning.png` | **EC2** → **Load Balancers** → `ASG-ALB` | State **provisioning**, 2 public subnets in different AZs, listener forwards to `ASG-TG`. |
| 5 | `Step_05_ALB_Active.png` | **EC2** → **Load Balancers** → `ASG-ALB` | State **active**, DNS name visible. |
| 6 | `Step_06_Auto_Scaling_Group.png` | **EC2** → **Auto Scaling Groups** → `WebServer-ASG` | Min **2**, Desired **2**, Max **6**; 2 private subnets; `ASG-TG` attached; `Scale-on-CPU` 70%. |
| 7 | `Step_07_ASG_Launch_Activity.png` | **EC2** → **Auto Scaling Groups** → **Activity** | Launch events, Status **Successful**, capacity 0 → 2. |
| 8 | `Step_08_Healthy_Targets.png` | **EC2** → **Target Groups** → **Targets** | 2 targets, both **healthy**, different AZs. |
| 9 | `Step_09_ALB_Browser_Test.png` | **Web browser** | Open `http://<ASG-ALB-DNS>/`. Page shows Instance ID and Auto Scaling demo content. |
| 10 | `Step_10_Instance_Terminated.png` | **EC2** → **Instances** | One `WebServer-ASG` instance **terminating** or **terminated**; Instance ID visible. |
| 11 | `Step_11_Auto_Healing_Activity.png` | **EC2** → **Auto Scaling Groups** → **Activity** | New launch after termination; Status **Successful**. |
| 12 | `Step_12_Recovery_Healthy.png` | **Target Groups** + **browser** | Console: 2 healthy targets again. Browser: ALB page still loads. |
| 13 | `Step_13_Recovery_Time.png` | Notes / text / spreadsheet | Three times + calculated recovery duration (e.g. 2 min 30 sec). |
| 14 | `Step_14_CPU_Scaling_Optional.png` | **EC2** → **Auto Scaling Groups** → **Activity** *(optional)* | Scale-out event if you ran CPU stress test. |

Full step instructions: [instructions.md](../instructions.md) · Console screenshot table: [instructions.md — AWS region and screenshot checklist](../instructions.md#aws-region-and-screenshot-checklist)

---

## Submission format

After each step:

1. Save the screenshot with the filename above.
2. Reply: `"Step N completed"` (e.g. `"Step 3 completed"`).
3. Attach or upload the matching screenshot.

**Minimum deliverables:** Steps **1–13** (Step 14 optional).
