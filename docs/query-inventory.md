# Query Inventory (by SOAR Stage)

## SOAR 0 — Contracts
- q_MxSchema_Contract
- q_MxCacheSchema_Contract
- q_MxRunLogSchema_Contract

## SOAR 1 — Data Sources, Execution, Persistence
- q_AccessSource
- q_EnvelopeResults
- q_DomainList
- q_MxCommandsConfig
- q_MxCommandsActive
- q_DomainCommandPairs
- q_MxToolboxOutput_Raw
- q_MxResultsCache_Seed
- q_MxCacheUpdate
- q_MxResultsCache
- q_MxRunLog_NewRows (collector only; no persistence yet)

## SOAR 2 — Thin Normalization
- q_MxToolboxOutput

## SOAR 3 — Projection / Scoring / Telemetry
- q_MxToolboxOutput_SOAR3
- q_MxToolboxScore_SOAR3
- q_MxPipelineTelemetry_SOAR3
- q_MxLeadershipOutput