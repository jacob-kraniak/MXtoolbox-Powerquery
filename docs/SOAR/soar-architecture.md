# SOAR Architecture (Power Query)

## Overview
This project uses a staged SOAR-style pipeline:
- SOAR 0: Schema Contracts
- SOAR 1: Execution & Persistence
- SOAR 2: Thin Normalization (Scalar-only)
- SOAR 3: Enrichment / Scoring / Telemetry

The purpose is to keep each stage deterministic, testable, and resilient to schema drift.

## Why “Contracts” (SOAR 0)
Value-based empty tables define canonical schemas to prevent:
- Column drift across refreshes
- Type widening (e.g., datetime -> any)
- Upstream changes breaking downstream steps

Contracts are intentionally:
- Side-effect free
- Not loaded to worksheets
- Not dependent on external sources

## SOAR 1: Execution & Persistence
SOAR 1:
- Builds Domain × MxCommand execution sets
- Executes raw lookups (pure functions)
- Maintains persisted cache with deterministic dedupe (1 row per Domain × MxCommand)
- Enforces cache schema contract at every read/write boundary

## SOAR 2: Thin Normalization
SOAR 2 outputs are presentation-safe:
- Scalar columns only
- No list/record expansions
- No “raw payload” exposure

## SOAR 3: Enrichment / Scoring / Telemetry
SOAR 3 is where you:
- Compute deterministic scores/tiers
- Produce telemetry (hit ratio, estimated requests)
- Optionally expand detail objects for analyst workflows (kept separate from reporting)

## Guardrails
- Contracts must never reference external sources
- Cache must have a single authoritative writer
- Seed readers must never depend on loaded cache outputs
- SOAR 2 is scalar-only
- Enrichment stays separate from reporting