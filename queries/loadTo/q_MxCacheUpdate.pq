// qMxCacheUpdate (fixed composite key)
let
    Cache = q_MxResultsCache,
    LatestRaw = q_MxToolboxOutput_Raw,

    LatestProjected =
        Table.SelectColumns(
            LatestRaw,
            {
                "MxToolbox Output.Domain",
                "MxToolbox Output.Command",
                "MxToolbox Output.MxRep",
                "MxToolbox Output.TimeRecorded"
            }
        ),

    LatestRenamed =
        Table.RenameColumns(
            LatestProjected,
            {
                {"MxToolbox Output.Domain", "Domain"},
                {"MxToolbox Output.Command", "MxCommand"},
                {"MxToolbox Output.MxRep", "MxReputation"},
                {"MxToolbox Output.TimeRecorded", "MxTimeRecorded"}
            }
        ),

    Combined = Table.Combine({Cache, LatestRenamed}),

    Sorted =
        Table.Sort(
            Combined,
            {
                {"Domain", Order.Ascending},
                {"MxCommand", Order.Ascending},
                {"MxTimeRecorded", Order.Descending}
            }
        ),

    // Keep newest per Domain+Command
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