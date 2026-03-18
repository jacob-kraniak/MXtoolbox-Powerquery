SOAR Playbook 1 — Bulk Domain Reputation Ingestion (FOUNDATION)
Purpose
Perform bulk domain reputation lookups using MXToolbox REST API and normalize results into a consistent, auditable dataset.
Trigger
	• Manual execution (initial POC run)
	• Scheduled execution (daily / weekly)
Inputs
	• CSV or list of domains (≥400)
	• MXToolbox API key
	• Rate‑limit configuration
Preconditions
	• Domains are normalized (lowercase, no empty values)
	• API key is securely stored
	• No automated enforcement enabled
Actions
	1. Load domain list
	2. De‑duplicate domains
	3. Perform MXToolbox API lookup per domain
	4. Capture full raw API response
	5. Normalize response fields
	6. Assign reputation tier (T1–T4)
	7. Persist results to structured output (CSV / JSON)
Outputs
	• Canonical Domain Reputation Dataset
	• Raw API evidence retained
	• Timestamped lookup results
Error Handling
	• Retry on transient API errors
	• Log failures without stopping batch
	• Rate‑limit backoff enforced
Notes
This playbook is mandatory before any automation or tagging.
