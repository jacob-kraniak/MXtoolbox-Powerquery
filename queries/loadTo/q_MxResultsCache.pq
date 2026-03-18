/*
==============================================================================
 Query Name : q_MxResultsCache
 SOAR Stage : SOAR 1 – Persisted Cache Store
 Load To    : ENABLED (tblMxCache)
 Expansion  : NONE
 Purpose    : Authoritative persisted MXToolbox cache table.
 Guardrails :
   - MUST be the only query that loads tblMxCache
   - MUST NOT read tblMxCache directly
==============================================================================
*/
let
    Source = qMxCacheUpdate
in
    Source