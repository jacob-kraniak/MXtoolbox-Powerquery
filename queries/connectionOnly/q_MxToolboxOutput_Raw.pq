// q_MxToolboxOutput_Raw (connection only)
// Same as original q_MxToolboxOutput expansion INCLUDING list columns
let
    Source = q_DomainCommandPairs,
    TopPairs = Table.FirstN(Source, pMaxAPICalls),
    TopPairsBuffered = Table.Buffer(TopPairs),

    Invoked =
        Table.AddColumn(
            TopPairsBuffered,
            "MxToolbox Output",
            each fnMxLookupWithCache([SenderDomain], [Command.Command])
        ),

    Expanded =
        Table.ExpandTableColumn(
            Invoked,
            "MxToolbox Output",
            {
                "UID","Domain","Command","CommandArgument","MxRep","DnsProvider","ReportingNameServer",
                "TimeRecorded","TimeToComplete","IsEndpoint","HasSubscriptions",
                "FailedCount","WarningsCount","PassedCount","TimeoutsCount",
                "FailedList","WarningsList","PassedList","TimeoutsList",
                "HasDmarcRecord"
            },
            {
                "MxToolbox Output.UID","MxToolbox Output.Domain","MxToolbox Output.Command","MxToolbox Output.CommandArgument",
                "MxToolbox Output.MxRep","MxToolbox Output.DnsProvider","MxToolbox Output.ReportingNameServer",
                "MxToolbox Output.TimeRecorded","MxToolbox Output.TimeToComplete","MxToolbox Output.IsEndpoint","MxToolbox Output.HasSubscriptions",
                "MxToolbox Output.FailedCount","MxToolbox Output.WarningsCount","MxToolbox Output.PassedCount","MxToolbox Output.TimeoutsCount",
                "MxToolbox Output.FailedList","MxToolbox Output.WarningsList","MxToolbox Output.PassedList","MxToolbox Output.TimeoutsList",
                "MxToolbox Output.HasDmarcRecord"
            }
        )
in
    Expanded