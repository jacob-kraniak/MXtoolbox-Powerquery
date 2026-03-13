let
    Source = Excel.CurrentWorkbook(){[Name="tblMxCache"]}[Content],
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Domain", type any}, {"MxCommand", type any}, {"MxReputation", type any}, {"MxTimeRecorded", type any}})
in
    #"Changed Type"
