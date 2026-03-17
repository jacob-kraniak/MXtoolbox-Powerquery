// q_MxToolboxOutput – multi-command, multi-domain
let
    Source = q_DomainCommandPairs,        // (SenderDomain, Command)
    
    // Still cap total API calls per refresh using pMaxAPICalls,
    // but now that limit is over *pairs* not just domains
    #"Top N Pairs" =
        Table.FirstN(Source, pMaxAPICalls),

    #"Invoked Custom Function" =
        Table.AddColumn(#"Top N Pairs", "MxToolbox Output", each fnMxLookupWithCache([SenderDomain], [Command.Command])),
    #"Expanded MxToolbox Output" = Table.ExpandTableColumn(#"Invoked Custom Function", "MxToolbox Output", {"UID", "Domain", "Command", "CommandArgument", "MxRep", "DnsProvider", "ReportingNameServer", "TimeRecorded", "TimeToComplete", "IsEndpoint", "HasSubscriptions", "FailedCount", "WarningsCount", "PassedCount", "TimeoutsCount", "FailedList", "WarningsList", "PassedList", "TimeoutsList", "HasDmarcRecord"}, {"MxToolbox Output.UID", "MxToolbox Output.Domain", "MxToolbox Output.Command", "MxToolbox Output.CommandArgument", "MxToolbox Output.MxRep", "MxToolbox Output.DnsProvider", "MxToolbox Output.ReportingNameServer", "MxToolbox Output.TimeRecorded", "MxToolbox Output.TimeToComplete", "MxToolbox Output.IsEndpoint", "MxToolbox Output.HasSubscriptions", "MxToolbox Output.FailedCount", "MxToolbox Output.WarningsCount", "MxToolbox Output.PassedCount", "MxToolbox Output.TimeoutsCount", "MxToolbox Output.FailedList", "MxToolbox Output.WarningsList", "MxToolbox Output.PassedList", "MxToolbox Output.TimeoutsList", "MxToolbox Output.HasDmarcRecord"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded MxToolbox Output",{{"MxToolbox Output.TimeRecorded", type datetimezone}, {"Command.Enabled", type logical}, {"MxToolbox Output.TimeToComplete", Int64.Type}, {"MxToolbox Output.IsEndpoint", type logical}, {"MxToolbox Output.FailedCount", Int64.Type}, {"MxToolbox Output.WarningsCount", Int64.Type}, {"MxToolbox Output.PassedCount", Int64.Type}, {"MxToolbox Output.TimeoutsCount", Int64.Type}, {"MxToolbox Output.HasDmarcRecord", type logical}})
in
    #"Changed Type"
