// q_EnvelopeResults
// This query directly retrieves your source data from an Excel Table, here named "tbl_EnvelopeResults". 
// All this needs to work is a single column with one "@domain.com" per row.

let
    Source = Excel.CurrentWorkbook(){[Name="tbl_EnvelopeResults"]}[Content],
    #"Changed Type" = Table.TransformColumnTypes(Source, {{"SenderFromDomain", type text}})
in
    #"Changed Type"
