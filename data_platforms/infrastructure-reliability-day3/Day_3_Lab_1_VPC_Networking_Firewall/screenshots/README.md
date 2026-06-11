# Lab 1 screenshots

Reference UI captures for instructors and participants are in **[reference/](reference/)**.

Participants save their own deliverables using the filenames below.

---

## Filename pattern

| Step | Save your screenshot as | Reference image(s) in [reference/](reference/) |
|------|-------------------------|--------------------------------------------------|
| 1 | `Step_01_VPC_Created.png` | `Step_01_VPC_Created.png` |
| 2 | `Step_02_Subnets_Created.png` | `Step_02_Subnets_Created.png` |
| 3 | `Step_03_IGW_Attached.png` | `Step_03_IGW_Attached.png` |
| 4 | `Step_04_Route_Tables.png` | `Step_04_Route_Tables.png` (+ Routes tab for `Public-RT` if needed) |
| 5 | `Step_05_NAT_Gateway.png` | `Step_05_NAT_GatewaypartA.png` · `Step_05_NAT_GatewaypartB.png` |
| 6 | `Step_06_NACL_Rules.png` | `Step_06_NACL_Rules.png` · `Step_06_NACL_Rulespart2.png` |
| 7 | `Step_07_Security_Groups.png` | `Step_07_Security_Groupsparta.png` · `Step_07_Security_Groupspartb.png` |
| 8 | `Step_08_Network_Firewall.png` | `Step_08_Network_Firewall.png` |
| 9 | `Step_09_Firewall_Endpoint.png` (optional) | `Step_09_Firewall_Endpoint.png` |
| — | — | `Lab 1.png` (VPC Resource map overview, optional) |

---

## What each screenshot must show

### Step 1 — VPC created
- **Page:** VPC → **Your VPCs**
- **Must show:** `Lab1-VPC` · CIDR `10.0.0.0/16` · State **Available** (green checkmark)
- **OK if you also see:** default VPC `172.31.0.0/16` — ignore it

### Step 2 — Subnets created
- **Page:** VPC → **Subnets**
- **Filter:** type `Lab1-VPC` in **Find subnets by attribute or tag** (this filter **works** on Subnets)
- **Must show:** all three subnets with correct CIDR: `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`

### Step 3 — Internet Gateway attached
- **Page:** VPC → **Internet gateways**
- **Must show:** `Lab1-IGW` · State **Attached** · VPC column `… \| Lab1-VPC`

### Step 4 — Route tables
- **Page:** VPC → **Route tables**
- **Filter:** `Lab1-VPC` (works on Route tables)
- **Must show:** `Public-RT`, `Private-RT`, `Firewall-RT` each with **one** explicit subnet association
- **Also OK:** a fourth row **Main** = Yes — that is the default main route table; do not delete it
- **Also capture:** select `Public-RT` → **Routes** tab → `0.0.0.0/0` → `igw-…`

### Step 5 — NAT Gateway
- **Part A — Page:** VPC → **NAT gateways** → click `Lab1-NAT`
  - State **Available** · Subnet `Public-Subnet-A` · Public IP allocated
- **Part B — Page:** VPC → **Route tables** → `Private-RT` → **Routes** tab
  - `0.0.0.0/0` → `nat-…` **Active**

### Step 6 — NACL rules
- **Part A — Page:** VPC → **Network ACLs** → `Web-Subnet-NACL` → **Inbound rules**
  - Rules 100, 110, 120 (your IP/32), 130, 200 visible
- **Part B — Same NACL → Subnet associations** tab
  - `Private-Subnet-B` associated

### Step 7 — Security groups
- **Page:** VPC → **Security groups**
- **Do not** type `Lab1-VPC` in the search box — it returns **No matching resource found** (see [instructions.md](../instructions.md#aws-console-how-to-find-your-lab-resources))
- **Search instead:** `Web-SG` then `Firewall-SG`, or match VPC ID in the **VPC** column
- **Part A:** `Web-SG` → **Inbound rules** (HTTP 80, SSH 22)
- **Part B:** `Firewall-SG` → **Inbound rules** (HTTP/HTTPS from `10.0.0.0/16`)

### Step 8 — Network Firewall
- **Pages:** VPC → **Network Firewall** → **Firewalls** (`Lab1-Firewall`, Status **READY**) and/or **Firewall policies** → `Lab1-Firewall-Policy`
- **Must show:** stateful rule group `Allow-Web-Traffic` attached to the policy

### Step 9 — Firewall endpoint (optional)
- **Page:** Network Firewall → **Firewalls** → `Lab1-Firewall` → **Details**
- **Must show:** Endpoint ID `vpce-…` · Status **READY** · subnet `Firewall-Subnet-A`

---

## Tips for a clear screenshot

1. Include **region** (top-right): **United States (N. Virginia)** / `us-east-1`
2. Include the **left navigation** item you are on (e.g. Subnets, Route tables)
3. Include the **resource name** column or page title
4. Use **Clear filters** before searching if a previous step’s filter is still active

See [instructions.md](../instructions.md) for full console steps and troubleshooting.
