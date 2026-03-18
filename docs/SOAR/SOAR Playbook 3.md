SOAR Playbook 3 — Reputation Reporting & Visibility
Purpose
Provide leadership‑ready visibility into domain health and reputation trends.
Trigger
	• Scheduled execution (daily / weekly)
	• On‑demand leadership request
Inputs
	• Domain Reputation Dataset
	• Historical reputation snapshots
Actions
	1. Aggregate domains by reputation tier
	2. Identify tier changes since last run
	3. Rank domains by risk and volume
	4. Generate summary metrics: 
		○ Total domains
		○ Tier distribution
		○ New High Risk / Malicious domains
	5. Export report (Excel / PDF / PPT‑ready)
Outputs
	• Executive summary report
	• SOC operational view
	• Delta‑based change report
Key Metrics
	• % of domains by tier
	• Net new T3/T4 domains
	• Domains remediated (tier improvement)
Notes
This playbook justifies licensing and future automation.