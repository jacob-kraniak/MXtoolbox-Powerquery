// q_MxToolboxDetail – one row per list item
let
    // Start from the parent query
    Source = q_MxToolboxOutput,

    // Keep only keys + scalar context + list columns
    #"Selected Columns" =
        Table.SelectColumns(
            Source,
            {
                "SenderDomain",
                "Command.Command",
                "Command.Category",
                "Command.Enabled",
                "MxToolbox Output.UID",
                "MxToolbox Output.Domain",
                "MxToolbox Output.Command",
                "MxToolbox Output.CommandArgument",
                "MxToolbox Output.MxRep",
                "MxToolbox Output.DnsProvider",
                "MxToolbox Output.ReportingNameServer",
                "MxToolbox Output.TimeRecorded",
                "MxToolbox Output.TimeToComplete",
                "MxToolbox Output.IsEndpoint",
                "MxToolbox Output.HasSubscriptions",
                "MxToolbox Output.FailedCount",
                "MxToolbox Output.WarningsCount",
                "MxToolbox Output.PassedCount",
                "MxToolbox Output.TimeoutsCount",
                "MxToolbox Output.FailedList",
                "MxToolbox Output.WarningsList",
                "MxToolbox Output.PassedList",
                "MxToolbox Output.TimeoutsList",
                "MxToolbox Output.HasDmarcRecord"
            }
        ),

    // Unpivot the four list columns into (ListType, ListValues)
    #"Unpivoted List Columns" =
        Table.Unpivot(
            #"Selected Columns",
            {
                "MxToolbox Output.FailedList",
                "MxToolbox Output.WarningsList",
                "MxToolbox Output.PassedList",
                "MxToolbox Output.TimeoutsList"
            },
            "ListType",
            "ListValues"
        ),

    // Optional: map long column names to clean list types
    #"Clean ListType" =
        Table.ReplaceValue(
            #"Unpivoted List Columns",
            "MxToolbox Output.",
            "",
            Replacer.ReplaceText,
            {"ListType"}
        ),

    // Expand the list into one row per item
    // (If each list item is a scalar, this is fine as-is.
    // If the list items are records, use ExpandRecordColumn instead.)
    #"Expanded ListValues" =
        Table.ExpandListColumn(
            #"Clean ListType",
            "ListValues"
        ),

    // Rename the list-value column to something meaningful
    #"Renamed Columns" =
        Table.RenameColumns(
            #"Expanded ListValues",
            {{"ListValues", "CheckDetail"}}
        ),
    #"Expanded CheckDetail" = Table.ExpandRecordColumn(#"Renamed Columns", "CheckDetail", {"ID", "Name", "Info", "Url", "PublicDescription", "IsExcludedByUser"}, {"CheckDetail.ID", "CheckDetail.Name", "CheckDetail.Info", "CheckDetail.Url", "CheckDetail.PublicDescription", "CheckDetail.IsExcludedByUser"})
in
    #"Expanded CheckDetail"
