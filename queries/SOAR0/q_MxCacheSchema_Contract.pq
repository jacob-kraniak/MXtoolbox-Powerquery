/*
==============================================================================
 Query Name : q_MxCacheSchema_Contract
 SOAR Stage : SOAR 0 – Cache Schema Contract
 Load To    : Not loaded
 Purpose    : Define the canonical schema for the persisted MXToolbox cache
              store (tblMxCache). Prevents type and column drift between
              Power Query and Access.

 Notes :
   - DISTINCT from q_MxSchema_Contract (API output contract)
   - Applies ONLY to SOAR 1 persistence layer
   - LastCheckedUTC is datetime (UTC-by-convention), not datetimezone

 Consumers :
   - q_MxResultsCache_Seed
   - q_MxCacheUpdate
   - q_MxResultsCache

 Guardrails :
   - MUST remain a value-based empty table
   - MUST NOT reference Access, Excel, or any loaded queries
==============================================================================
*/
let
    SchemaType =
        type table [
            Domain         = text,
            MxCommand      = text,
            LastCheckedUTC = datetime,
            CacheStatus    = text,
            RunID          = text
        ],

    SchemaValue =
        #table(
            SchemaType,
            {}
        )
in
    SchemaValue