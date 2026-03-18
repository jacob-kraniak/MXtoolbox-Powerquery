SOAR Playbook 2 — Domain Reputation Tiering & Tagging
Purpose
Apply standardized reputation tiers and tags to domains based on MXToolbox findings.
Trigger
	• Successful completion of Playbook 1
	• New or updated domain lookup result
Inputs
	• Normalized MXToolbox response
	• Tier classification logic
Tier Definitions
	• T1_Clean — No blacklist, no critical findings
	• T2_Degraded — Misconfiguration or weak signals
	• T3_HighRisk — Blacklisted or multiple critical failures
	• T4_Malicious — Persistent listings or confirmed abuse
Actions
	1. Evaluate MXToolbox findings
	2. Assign reputation tier
	3. Apply tags: 
		○ reputation:T1_clean
		○ reputation:T2_degraded
		○ reputation:T3_high_risk
		○ reputation:T4_malicious
	4. Add metadata: 
		○ Source: MXToolbox
		○ LastChecked timestamp
Outputs
	• Tagged domain records
	• Tiered reputation classification
Safety Controls
	• No blocking or enforcement
	• Tier logic must be deterministic and auditable