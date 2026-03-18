SOAR Playbook 5 — Automated Containment (OPTIONAL / PHASE 2)
Purpose
Safely contain high‑risk domains only when corroborated by internal telemetry.
Trigger
	• Domain tier escalates to T3 or T4
	• AND domain observed internally within defined time window
Preconditions
	• Tier logic validated
	• Leadership approval obtained
	• Rollback procedures documented
Inputs
	• Reputation tier change event
	• Internal telemetry correlation
Actions
	1. Validate domain activity internally
	2. Apply temporary containment: 
		○ Email block (time‑boxed)
		○ Network deny (optional)
	3. Notify SOC and stakeholders
	4. Open investigation case
	5. Schedule re‑evaluation
Outputs
	• Containment action log
	• Incident record
	• Reassessment schedule
Safety Controls
	• Time‑limited actions
	• Automatic rollback
	• Manual override available
Notes
This playbook should be piloted on a small domain set only.