// q_MxToolboxOutput_Raw (optimized for SOAR 4 evidence)
let
    Source = q_MxToolboxOutput_Raw,

    // Optional: only keep rows likely to matter operationally
    // (adjust condition if your tier logic is elsewhere)
    Filtered =
        Table.SelectRows(
            Source,
            each [MxToolbox Output.FailedCount] > 0 or [MxToolbox Output.WarningsCount] > 0
        ),

    Selected =
        Table.SelectColumns(
            Filtered,
            {
                "SenderDomain",
                "Command.Command",
                "Command.Category",
                "Command.Enabled",
                "MxToolbox Output.UID",
                "MxToolbox Output.Domain",
                "MxToolbox Output.Command",
                "MxToolbox Output.TimeRecorded",
                "MxToolbox Output.MxRep",
                "MxToolbox Output.FailedCount",
                "MxToolbox Output.WarningsCount",
                "MxToolbox Output.FailedList",
                "MxToolbox Output.WarningsList"
            }
        ),

    Buffered = Table.Buffer(Selected),

    Unpivoted =
        Table.Unpivot(
            Buffered,
            {
                "MxToolbox Output.FailedList",
                "MxToolbox Output.WarningsList"
            },
            "ListType",
            "ListValues"
        ),

    CleanListType =
        Table.ReplaceValue(
            Unpivoted,
            "MxToolbox Output.",
            "",
            Replacer.ReplaceText,
            {"ListType"}
        ),

    ExpandedList =
        Table.ExpandListColumn(
            CleanListType,
            "ListValues"
        ),

    Renamed =
        Table.RenameColumns(
            ExpandedList,
            {{"ListValues", "CheckDetail"}}
        ),

    ExpandedCheckDetail =
        Table.ExpandRecordColumn(
            Renamed,
            "CheckDetail",
            {"ID", "Name", "Info", "Url", "PublicDescription", "IsExcludedByUser"},
            {"CheckDetail.ID", "CheckDetail.Name", "CheckDetail.Info", "CheckDetail.Url", "CheckDetail.PublicDescription", "CheckDetail.IsExcludedByUser"}
        )
in
    ExpandedCheckDetail