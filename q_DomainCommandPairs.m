// q_DomainCommandPairs
let
    Domains  = q_DomainList,   // SenderDomain
    Commands = q_MxCommandsActive,   // {"mx","a","spf"} etc

    AddCommandList =
        Table.AddColumn(
            Domains,
            "CommandList",
            each Commands
        ),

    Expanded =
        Table.ExpandListColumn(
            AddCommandList,
            "CommandList"
        ),

    Renamed =
        Table.RenameColumns(
            Expanded,
            {{"CommandList", "Command"}}
        ),
    #"Expanded Command" = Table.ExpandRecordColumn(Renamed, "Command", {"Command", "Category", "Enabled"}, {"Command.Command", "Command.Category", "Command.Enabled"})
in
    #"Expanded Command"
