/*
==============================================================================
 Query Name : q_DomainList
 SOAR Stage : SOAR 1 – Domain Extraction & De-duplication
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Extract, normalize, and de-duplicate sender domains from
              envelope data to produce a clean domain list for lookup.
 Dependencies :
   - q_EnvelopeResults
 Consumers :
   - q_DomainCommandPairs
 Guardrails :
   - MUST remain deterministic and side-effect free
   - No API calls or external lookups in
*/
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
