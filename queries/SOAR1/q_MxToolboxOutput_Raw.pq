/*
==============================================================================
 Query Name : q_MxToolboxOutput_Raw
 SOAR Stage : SOAR 1 – Raw API Execution
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Execute MXToolbox lookups for each Domain × MxCommand pair
              and return canonical raw results.
 Dependencies :
   - q_DomainCommandPairs
   - fnMxLookup_Raw
 Consumers :
   - q_MxCacheUpdate
   - q_MxToolboxOutput (SOAR 2)
 Guardrails :
   - MUST NOT reference cache or Access
   - MUST NOT duplicate identity columns
==============================================================================
*/

let
    /* 1. Canonical execution set */
    ExecutionSet =
        q_DomainCommandPairs,

    /* 2. Invoke API function (DO NOT type the column) */
    WithRawResult =
        Table.AddColumn(
            ExecutionSet,
            "RawResult",
            each fnMxLookup_Raw([Domain], [MxCommand])
        ),

    /* 3. Expand NON‑IDENTITY fields only (static list) */
    Expanded =
        Table.ExpandTableColumn(
            WithRawResult,
            "RawResult",
            {
                "UID",
                "CommandArgument",
                "MxRep",
                "DnsProvider",
                "ReportingNameServer",
                "TimeRecorded",
                "TimeToComplete",
                "IsEndpoint",
                "HasSubscriptions",
                "FailedCount",
                "WarningsCount",
                "PassedCount",
                "TimeoutsCount",
                "FailedList",
                "WarningsList",
                "PassedList",
                "TimeoutsList",
                "HasDmarcRecord"
            }
        ),

    Final =
        Expanded
in
    Final