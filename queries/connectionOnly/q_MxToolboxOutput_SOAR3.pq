/*
==============================================================================
 Query Name : q_MxToolboxOutput_SOAR3
 SOAR Stage : SOAR 3 – Scalar Projection
 Load To    : Connection Only
 Expansion  : NONE (Scalar only)
 Purpose    : Project approved, presentation-safe MXToolbox indicators
              from SOAR‑3 enrichment into a reusable scalar dataset.
 Consumers :
   - Leadership views
   - SOAR 4 dashboards
   - Exports
 Guardrails :
   - MUST remain scalar
   - MUST NOT expose raw API objects
==============================================================================
*/
let
    Source = q_MxToolboxOutput_Raw,

    Projected =
        Table.AddColumn(
            Source,
            "Projection",
            each [
                MxCommand           = Record.FieldOrDefault([MxToolboxOutput_Raw], "Command", null),
                MxReputation        = Record.FieldOrDefault([MxToolboxOutput_Raw], "MxRep", null),
                MxTimeRecorded      = Record.FieldOrDefault([MxToolboxOutput_Raw], "TimeRecorded", null),
                FailedCount         = Record.FieldOrDefault([MxToolboxOutput_Raw], "FailedCount", null),
                WarningsCount       = Record.FieldOrDefault([MxToolboxOutput_Raw], "WarningsCount", null),
                TimeoutsCount       = Record.FieldOrDefault([MxToolboxOutput_Raw], "TimeoutsCount", null),
                DnsProvider         = Record.FieldOrDefault([MxToolboxOutput_Raw], "DnsProvider", null),
                ReportingNameServer = Record.FieldOrDefault([MxToolboxOutput_Raw], "ReportingNameServer", null),
                HasDmarcRecord      = Record.FieldOrDefault([MxToolboxOutput_Raw], "HasDmarcRecord", null)
            ],
            type record
        ),

    Flattened =
        Table.ExpandRecordColumn(
            Projected,
            "Projection",
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
        )
in
    Flattened