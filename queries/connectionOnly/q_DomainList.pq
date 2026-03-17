// q_DomainList
let
    Source = q_EnvelopeResults,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"SenderFromDomain"}),
    #"Trimmed Text" = Table.TransformColumns(#"Removed Other Columns",{{"SenderFromDomain", Text.Trim, type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Trimmed Text"),
    #"Removed Blank Rows" = Table.SelectRows(#"Removed Duplicates", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    #"Lowercased Text" = Table.TransformColumns(#"Removed Blank Rows",{{"SenderFromDomain", Text.Lower, type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Lowercased Text",{{"SenderFromDomain", "SenderDomain"}})
in
    #"Renamed Columns"
