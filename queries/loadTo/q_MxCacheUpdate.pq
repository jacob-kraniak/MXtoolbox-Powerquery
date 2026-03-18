// qMxCacheUpdate (SOAR 1 compliant – no expansion)
let
    Cache = q_MxResultsCache,
    LatestRaw = q_MxToolboxOutput_Raw,

    LatestProjected =
        Table.AddColumn(
            LatestRaw,
            "Projection",
            each [
                Domain        = Record.FieldOrDefault([MxToolboxOutput_Raw], "Domain", null),
                MxCommand     = Record.FieldOrDefault([MxToolboxOutput_Raw], "Command", null),
                MxReputation  = Record.FieldOrDefault([MxToolboxOutput_Raw], "MxRep", null),
                MxTimeRecorded= Record.FieldOrDefault([MxToolboxOutput_Raw], "TimeRecorded", null)
            ],
            type record
        ),

    Flattened =
        Table.ExpandRecordColumn(
            LatestProjected,
            "Projection",
            {"Domain","MxCommand","MxReputation","MxTimeRecorded"}
        ),

    Combined = Table.Combine({Cache, Flattened}),

    Sorted =
        Table.Sort(
            Combined,
            {
                {"Domain", Order.Ascending},
                {"MxCommand", Order.Ascending},
                {"MxTimeRecorded", Order.Descending}
            }
        ),

    Deduped =
        Table.Distinct(
            Sorted,
            {"Domain", "MxCommand"}
        ),

    CacheForTable =
        Table.TransformColumnTypes(
            Deduped,
            {
                {"Domain", type text},
                {"MxCommand", type text},
                {"MxReputation", type any},
                {"MxTimeRecorded", type datetime}
            }
        )
in
    CacheForTable