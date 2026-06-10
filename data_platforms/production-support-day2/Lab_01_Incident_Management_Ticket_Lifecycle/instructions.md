# Lab 1: Incident Management and Ticket Lifecycle

**Estimated time:** 20–25 minutes

**Tools needed:** Microsoft Excel or Google Sheets

> **Optional:** Copy [tmpl/lab1_starter.xlsx](tmpl/lab1_starter.xlsx) instead of starting from a blank workbook in Step 1.

---

## Lab Objectives

By the end of this lab, you will be able to:
- Identify and categorize production incidents
- Assign correct priority (P1–P4) using a severity matrix
- Simulate ticket routing through L1 → L2 → L3 support tiers
- Apply escalation rules based on SLA time thresholds
- Document resolution and close an incident properly

---

## Reference Materials (Provided Below)

| Document | Location |
|----------|----------|
| Severity Matrix (P1–P4) | Included in Step 2 |
| Escalation Rules | Included in Step 5 |
| Sample Ticket Data | Included in Step 4 |

---

## Step 1 – Create Your Excel Workbook

**Action:**

1. Open **Microsoft Excel** or **Google Sheets**
2. Create a **new blank workbook**
3. Save it as: `lab1_incident_tickets.xlsx`

**Deliverable:** Screenshot showing empty workbook with filename

**Reply:** `"M1 done"` + upload screenshot

---

## Step 2 – Create Ticket Log Sheet

**Action:**

In `lab1_incident_tickets.xlsx`, create a sheet named **Ticket Log**

Add these **column headers** in Row 1:

| A | B | C | D | E | F | G | H | I |
|---|---|---|---|---|---|---|---|---|
| Ticket ID | Created Date | Created Time | Priority | Category | Summary | Description | Current Tier | Status |

**Deliverable:** Screenshot showing the Ticket Log sheet with column headers

**Reply:** `"M2 done"` + upload screenshot

---

## Step 3 – Add Severity Matrix Reference Sheet

**Action:**

Create a **second sheet** in the same Excel file named **Severity Matrix**

Copy this table into the sheet:

| Priority | Definition | Response SLA | Resolution SLA | Example |
|----------|------------|--------------|----------------|---------|
| P1 | Critical business outage, no workaround | 5 minutes | 1 hour | Login down, checkout failing |
| P2 | Major feature broken, workaround exists | 15 minutes | 4 hours | Search slow, manual workaround |
| P3 | Minor issue, low user impact | 1 hour | 24 hours | Reporting export missing column |
| P4 | Cosmetic issue, question, documentation | 4 hours | 48 hours | UI typo, "how do I..." |

**Deliverable:** Screenshot showing the Severity Matrix sheet

**Reply:** `"M3 done"` + upload screenshot

---

## Step 4 – Create Your First Incident Ticket

**Scenario:** You receive a report: *"All transactions are failing with error code PAY-500. No workaround. Revenue impacted."*

**Action:**

In the **Ticket Log** sheet, add this row:

| A | B | C | D | E | F | G | H | I |
|---|---|---|---|---|---|---|---|---|
| INC-001 | 2026-06-10 | 09:00 | P1 | Payment API | Payment API returning PAY-500 | 100% failure rate. No workaround. Impacting all merchants. | L1 | Open |

**Deliverable:** Screenshot showing the Ticket Log with INC-001 added

**Reply:** `"M4 done"` + upload screenshot

---

## Step 5 – Create Escalation Rules Reference

**Action:**

Create a **third sheet** named **Escalation Rules**

Copy this table:

| From Tier | To Tier | P1 | P2 | P3 | P4 |
|-----------|---------|-----|-----|-----|-----|
| L1 | L2 | 5 minutes | 15 minutes | 1 hour | 4 hours |
| L2 | L3 | 30 minutes | 2 hours | 8 hours | N/A |

**Deliverable:** Screenshot showing Escalation Rules sheet

**Reply:** `"M5 done"` + upload screenshot

---

## Step 6 – Simulate L1 Troubleshooting

**Scenario:** You are the L1 engineer. You try restarting the payment API service. It does NOT fix the issue. 5 minutes have passed.

**Action:**

In the **Ticket Log** sheet, update the INC-001 row:

- Change **Status** from `Open` to `Escalated to L2`
- Add a **new column** called `Escalation Time` (Column J) and enter `5 min`

**Deliverable:** Screenshot showing the updated ticket status

**Reply:** `"M6 done"` + upload screenshot

---

## Step 7 – Simulate L2 Investigation

**Scenario:** You now act as L2 engineer. You check logs and find the database connection pool is exhausted (1000/1000 used). You increase it to 2000. The issue is fixed in 12 minutes.

**Action:**

In the **Ticket Log** sheet:

- Add a **new column** called `Root Cause` (Column K) and enter: `Connection pool exhausted`
- Add a **new column** called `Resolution Action` (Column L) and enter: `Increased pool size from 1000 to 2000`
- Change **Status** to `Resolved - Pending Verification`

**Deliverable:** Screenshot showing the ticket with root cause and resolution

**Reply:** `"M7 done"` + upload screenshot

---

## Step 8 – Simulate User Verification and Closure

**Scenario:** The user confirms transactions are working again.

**Action:**

In the **Ticket Log** sheet:

- Change **Status** to `Closed`
- Add a **new column** called `Resolution Category` (Column M) and enter: `Configuration Change`

**Deliverable:** Screenshot showing the completed ticket (all columns filled)

**Reply:** `"M8 done"` + upload screenshot

---

## Step 9 – Practice Additional Tickets

**Action:**

Add **two more tickets** to your Ticket Log sheet:

| Ticket ID | Priority | Category | Summary | Current Tier | Status |
|-----------|----------|----------|---------|--------------|--------|
| INC-002 | P2 | Search API | Search returns results after 8 seconds (manual workaround available) | L1 | Open |
| INC-003 | P3 | Reporting | Monthly report export missing "region" column | L1 | Open |

**For each ticket, decide:**
- Should it stay at L1 or escalate to L2?
- If escalate, after how many minutes?

Write your decision in a **new column** called `Escalation Decision`

**Deliverable:** Screenshot showing INC-002 and INC-003 added with escalation decisions

**Reply:** `"M9 done"` + upload screenshot

---

## Step 10 – Final Deliverables Checklist

Verify your Excel file contains:

| # | Sheet Name | Content |
|---|------------|---------|
| 1 | Ticket Log | INC-001, INC-002, INC-003 with all columns |
| 2 | Severity Matrix | P1–P4 definitions |
| 3 | Escalation Rules | L1→L2→L3 time thresholds |

**Final Action:** Save your Excel file as `lab1_[yourname].xlsx`

**Deliverable:** Screenshot showing all three sheets (tabs) at the bottom of Excel

**Reply:** `"M10 done – Lab 1 complete"` + upload final screenshot

---

## Bonus Challenge (Optional)

**Scenario:** A P1 ticket was fixed in 10 minutes, but no one updated the ticket status for 2 hours.

**Question:** Did this violate SLA? Why?

Write your answer in a few sentences. Discuss with your instructor or group after completing the lab.

---

## Summary – What You Learned

| Concept | How You Applied It |
|---------|---------------------|
| P1–P4 Priority | Assigned based on business impact |
| Severity Matrix | Used definitions to classify incidents |
| Escalation Rules | L1→L2 after SLA time thresholds |
| Ticket Lifecycle | Created → Triaged → Escalated → Fixed → Verified → Closed |
| Root Cause | Documented in ticket |
| Resolution Category | Configuration Change |

---

## Troubleshooting Tips for Participants

| Problem | Solution |
|---------|----------|
| Can't find column to insert | Right-click on the column LETTER (e.g., "J"), not a cell |
| Text gets cut off | Double-click between column letters to auto-fit width |
| Accidentally closed Excel | Check File → Open → Recent or AutoRecovery files |
| Using Google Sheets | Right-click column letter → "Insert 1 column" |
| Sheet tabs not visible | Look at bottom-left corner, click the arrows or + sign |

---

## Ready to Begin?

Reply with: `"M1 done"` and your first screenshot showing the empty Excel workbook.

Follow the steps sequentially from M1 to M10.

**Good luck, incident managers!** 🚨
