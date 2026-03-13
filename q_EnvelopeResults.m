// q_EnvelopeResults
let
    Source = Excel.CurrentWorkbook(){[Name="tbl_EnvelopeResults"]}[Content],
    #"Changed Type" = Table.TransformColumnTypes(Source, {{"SenderFromDomain", type text}})
in
    #"Changed Type"
