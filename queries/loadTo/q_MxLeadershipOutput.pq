// q_MxLeadershipOutput (new)
let
    Source = q_MxToolboxOutput_Raw,

    // Keep only leadership / SOAR 3 & SOAR 4 reporting needs:
    // Tier logic can be added here or in a separate tiering query
    Selected =
        Table.SelectColumns(
            Source,
            {
                "SenderDomain",
                "MxToolbox Output.Command",
                "MxToolbox Output.MxRep",
                "MxToolbox Output.TimeRecorded",
                "MxToolbox Output.FailedCount",
                "MxToolbox Output.WarningsCount",
                "MxToolbox Output.TimeoutsCount",
                "MxToolbox Output.DnsProvider",
                "MxToolbox Output.ReportingNameServer",
                "MxToolbox Output.HasDmarcRecord"
            }
        ),

    // Example simple “EvidenceSummary” (cheap string)
    EvidenceSummary =
        Table.AddColumn(
            Selected,
            "EvidenceSummary",
            each
                "F:" & Text.From([MxToolbox Output.FailedCount]) &
                " W:" & Text.From([MxToolbox Output.WarningsCount]) &
                " T:" & Text.From([MxToolbox Output.TimeoutsCount]),
            type text
        )
in
    EvidenceSummary