SOAR Playbook 4 — Conditional Alert Enrichment (XDR‑Aligned)
Purpose
Enrich security alerts with domain reputation context when correlated activity occurs.
Trigger
	• Security event involving a domain
	• Email, DNS, or network telemetry reference
Conditions
	• Domain has tier T3_HighRisk or T4_Malicious
Inputs
	• Alert event
	• Domain reputation dataset
Actions
	1. Match domain against reputation dataset
	2. Enrich alert with: 
		○ Reputation tier
		○ MXToolbox evidence summary
		○ LastChecked timestamp
	3. Increase alert priority
	4. Attach SOAR context to case
Outputs
	• Enriched alert
	• Context‑aware SOC triage
Safety Controls
	• No automatic blocking
	• Analyst decision required
Notes
Designed to map cleanly into SentinelOne XDR correlation logic.