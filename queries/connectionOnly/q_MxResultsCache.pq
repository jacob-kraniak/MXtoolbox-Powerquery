// q_MxResultsCache
// Reads the persisted cache table from Excel (breaks cyclic dependencies).

let
    Source = Excel.CurrentWorkbook(){[Name = "tblMxCache"]}[Content],
    #"Changed Type" =
        Table.TransformColumnTypes(
            Source,
            {
                {"Domain",         type text},
                {"MxCommand",      type text},
                {"MxReputation",   type any},
                {"MxTimeRecorded", type datetime}
            }
        )
in
    #"Changed Type"