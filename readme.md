#SOAR Staging Model

This project follows a staged “SOAR” pipeline design to keep Power Query deterministic, debuggable, and scalable.

##SOAR 0 — Contracts (Schema Definitions)
Value-based empty tables define canonical schemas to prevent type drift and value leakage. Examples include cache schema contracts and output contracts.

##SOAR 1 — Execution & Persistence
Build the Domain × Command execution set, perform MXToolbox lookups, and maintain a persisted cache. Persistence is handled via an Access database source and contract-enforced cache maintenance queries. 

##SOAR 2 — Thin Normalization (Scalar Only)
Normalize only top-level scalar fields required for reporting/consumption. Avoid expanding list-heavy payloads.


##SOAR 3 — Enrichment / Scoring / Telemetry
Produce “presentation-safe” scalar projections, deterministic scoring/tiering, and pipeline telemetry (e.g., cache hit ratio and estimated request volume). 

#High-Level Data Flow

1. Domain Source → persisted domain inventory (Access) read into Power Query. 
2. Domain Normalization → trim/lowercase/dedupe into a canonical domain list. 
3. Domain × Command Pairing → cartesian product of domains and enabled commands. 
4. Lookup Execution (Raw) → pure API execution function returns canonical shaped results.
5. Cache Maintenance → merge new results into persisted cache using contract schema enforcement and dedupe to 1 row per Domain × MxCommand.
6. SOAR 2/3 Outputs → scalar outputs, scoring, and telemetry views.

#Guardrails (Non-Negotiables)
These rules are enforced in query headers and should be preserved across refactors:

 - Contracts are value-based and side-effect free (SOAR 0).
 - Persistence has a single authoritative writer: only the cache-output query should load the cache table.
 - Seed readers must never read from the loaded cache output (avoid cyclic dependencies). 
 - SOAR 1 execution should not expand list-heavy payloads (keep it stable and performant). 
 - SOAR 2 outputs must remain scalar for reporting safety.
 - SOAR 3 may expand details, but should remain clearly separated from reporting views.
 

#Repository Layout

 - params/ — reference parameter definitions (configure actual values in Power Query “Manage Parameters”).
 - functions/ — Power Query functions invoked by execution stages.
 - queries/ — staged queries implementing the SOAR pipeline.
 - docs/ — architecture notes, query inventory, and operational guidance (added by this commit).