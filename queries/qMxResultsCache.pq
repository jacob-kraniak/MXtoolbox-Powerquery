// qMxResultsCache
// Reads the limited cache table from Excel table tblMxCache.

let
    Source =
        Excel.CurrentWorkbook(){[Name = "tblMxCache"]}[Content],

    #"Changed Type" =
        Table.TransformColumnTypes(
            Source,
            {
                {"Domain",        type text},
                {"MxCommand",     type text},
                {"MxReputation",  type any},
                {"MxTimeRecorded", type datetime}
            }
        )
in
    #"Changed Type"