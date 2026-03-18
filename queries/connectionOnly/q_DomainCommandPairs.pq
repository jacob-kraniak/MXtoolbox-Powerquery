/*
==============================================================================
 Query Name : q_DomainCommandPairs
 SOAR Stage : SOAR 1 – Domain × Command Cartesian Pairing
 Load To    : Connection Only
 Expansion  : LISTS / RECORDS (Controlled)
 Purpose    : Generate the Cartesian pairing of sender domains and active
              MXToolbox commands to define the full lookup execution set.
 Dependencies :
   - q_DomainList
   - q_MxCommandsActive
 Consumers :
   - q_MxToolboxOutput_Raw
 Guardrails :
   - Expansion is limited to command pairing only
   - MUST NOT invoke APIs or perform lookups in this
*/
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