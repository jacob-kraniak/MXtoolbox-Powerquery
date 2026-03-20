
SOAR Configuration Panel
MXToolbox Domain Reputation Pipeline


Purpose
Provide a single, controlled interface for configuring SOAR pipeline behavior (API scope, throttling, caching) without modifying Power Query code or Advanced Editor logic. This panel is designed for pre-execution configuration, not interactive analytics.
Design goals:

Deterministic, auditable execution
Clear SOAR-stage boundaries
Safe for operational and leadership use
Refresh-driven (no live API interaction)


Placement & Usage

Dedicated page: SOAR Configuration
Appears before reporting and analytics pages
Configuration changes take effect only after dataset refresh


⚠️ This panel does not trigger automation, blocking, or containment.




Section 1 — Pipeline Status (Read-Only)
Intent: Immediate operator context
Displayed elements:

Pipeline Mode: SOAR 1–3 (Reputation Ingestion & Reporting)
Last Refresh Timestamp
Domains Processed (last run)
API Calls Executed (last run)


Section 2 — Lookup Scope Controls
DNS Lookups

Parameter: pUseDnsLookups
Type: Boolean
Purpose: Enable DNS-category MXToolbox commands (SPF, DMARC, DKIM)
Operator guidance:

Default: true
Safe for free-tier usage


Network Lookups (Future Phase)

Parameter: pUseNetworkLookups
Type: Boolean
Purpose: Enable Network-category lookups (blacklist, smtp, tcp)
Operator guidance:

Default: false
Intended for paid tier / future expansion


Section 3 — API Throttling & Cost Controls
API Call Cap

Parameter: pMaxAPICalls
Purpose: Hard limit on API calls per refresh cycle
Usage patterns:

Low value → testing / demos
High value → bulk domain sweeps


Inter-Call Delay

Parameter: pMinDelayMs
Purpose: Minimum delay between successive API calls (milliseconds)
Notes:

Applies only when cache is stale
Helps avoid rate limiting


Section 4 — Cache Behavior
Cache Freshness Window

Parameter: pCacheDays
Purpose: Number of days cached results remain valid
Trade-off:

Higher value → fewer API calls, staler data
Lower value → fresher data, higher cost
Cache Characteristics (Read-Only)

Cache key: Domain + Command
Most recent entry retained
Cache breaks cyclic dependencies


Section 5 — API Configuration (Read-Only)
Endpoint

Parameter: pMxApiBaseUrl
MXToolbox REST v1 lookup endpoint
Authentication

Parameter: pMxApiKey
Stored securely
Masked in UI


🔒 API keys must never be displayed, exported, or hardcoded in reports.




Section 6 — Execution Controls
Actions:

Refresh Dataset
Navigate to Reporting / Leadership Views
Safety statement:


Configuration changes require explicit refresh and do not perform automated containment or enforcement.




Design Principles

Power Query Parameters only (no slicer-bound API behavior)
Refresh-driven execution for auditability
Read-only by default except for explicit parameter edits
SOAR-aligned with stages 1–3


Future Enhancements (Optional)

Bookmark presets (e.g., DNS-only safe run, Bulk sweep)
Configuration snapshot per run
Change log for parameter updates


Summary
The SOAR Configuration Panel provides a safe control surface for operational tuning of the MXToolbox pipeline. It prioritizes predictability, transparency, and governance over interactivity, making it suitable for production SOAR workflows and leadership visibility.
