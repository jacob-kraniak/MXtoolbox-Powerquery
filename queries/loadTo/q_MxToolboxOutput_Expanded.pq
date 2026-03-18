/*
==============================================================================
 Query Name : q_MxToolboxOutput_Expanded
 SOAR Stage : SOAR 3 – Detail Expansion & Enrichment
 Load To    : Connection Only
 Expansion  : LISTS / RECORDS (Intentional)
 Purpose    : Expand MXToolbox per-check detail lists for analyst
*/
let
    Source = q_MxToolboxOutput_Raw,

    Projected =
        Table.AddColumn(
            Source,
            "Projection",
            each [
                MxCommand          = Record.FieldOrDefault([MxToolboxOutput_Raw], "Command", null),
                MxReputation       = Record.FieldOrDefault([MxToolboxOutput_Raw], "MxRep", null),
                MxTimeRecorded     = Record.FieldOrDefault([MxToolboxOutput_Raw], "TimeRecorded", null),
                FailedCount        = Record.FieldOrDefault([MxToolboxOutput_Raw], "FailedCount", null),
                WarningsCount      = Record.FieldOrDefault([MxToolboxOutput_Raw], "WarningsCount", null),
                TimeoutsCount      = Record.FieldOrDefault([MxToolboxOutput_Raw], "TimeoutsCount", null),
                DnsProvider        = Record.FieldOrDefault([MxToolboxOutput_Raw], "DnsProvider", null),
                ReportingNameServer= Record.FieldOrDefault([MxToolboxOutput_Raw], "ReportingNameServer", null),
                HasDmarcRecord     = Record.FieldOrDefault([MxToolboxOutput_Raw], "HasDmarcRecord", null)
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