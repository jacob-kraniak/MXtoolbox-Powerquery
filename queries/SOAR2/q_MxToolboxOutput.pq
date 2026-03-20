/*
==============================================================================
 Query Name : q_MxToolboxOutput
 SOAR Stage : SOAR 2 – Thin Normalization
 Load To    : Connection Only
 Expansion  : TABLE (Single-row envelope only)
 Purpose    : Normalize top-level scalar MXToolbox output fields while
              preserving 1 row = 1 SenderDomain × Command.
 Dependencies :
   - q_MxToolboxOutput_Raw
 Guardrails :
   - MUST NOT expand list fields
   - MUST NOT reference [MxToolbox Output] after expansion
==============================================================================
*/

let
    Source = q_MxToolboxOutput_Raw,

    // Expand the single-row table returned by fnMxLookupWithCache
    Expanded =
        Table.ExpandTableColumn(
            Source,
            "MxToolbox Output",
            {
                "Command",
                "MxRep",
                "TimeRecorded",
                "FailedCount",
                "WarningsCount",
                "TimeoutsCount",
                "DnsProvider",
                "ReportingNameServer",
                "HasDmarcRecord"
            },
            {
                "MxCommand",
                "MxReputation",
                "MxTimeRecorded",
                "FailedCount",
                "WarningsCount",
                "TimeoutsCount",
                "DnsProvider",
                "ReportingNameServer",
                "HasDmarcRecord"
            }
        ),

    // Enforce SOAR‑2 scalar schema only
    Typed =
        Table.TransformColumnTypes(
            Expanded,
            {
                {"SenderDomain", type text},
                {"MxCommand", type text},
                {"MxReputation", type any},
                {"MxTimeRecorded", type datetime},
                {"FailedCount", Int64.Type},
                {"WarningsCount", Int64.Type},
                {"TimeoutsCount", Int64.Type},
                {"DnsProvider", type text},
                {"ReportingNameServer", type text},
                {"HasDmarcRecord", type logical}
            }
        ),
    #"Renamed Columns" = Table.RenameColumns(Typed,{{"SenderDomain", "Domain"}})
in
    #"Renamed Columns"