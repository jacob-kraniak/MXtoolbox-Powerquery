// qMxCacheUpdate
// Updates the limited cache table by merging existing cache with latest MXToolbox output,
// then keeping the newest entry per Domain.

// NOTE: Set this query to "Load To..." -> Table -> tblMxCache.

let
    // 1) Existing limited cache
    Cache = qMxResultsCache,      // (Domain, MxCommand, MxReputation, MxTimeRecorded)

    // 2) Latest MXToolbox output (full result set)
    LatestRaw = q_MxToolboxOutput,

    // Project to the four columns we need for the limited cache
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
                {"MxToolbox Output.Domain",      "Domain"},
                {"MxToolbox Output.Command",     "MxCommand"},
                {"MxToolbox Output.MxRep",       "MxReputation"},
                {"MxToolbox Output.TimeRecorded","MxTimeRecorded"}
            }
        ),

    // 3) Combine old cache + latest run
    Combined = Table.Combine({Cache, LatestRenamed}),

    // 4) Sort so newest MxTimeRecorded comes first per Domain
    Sorted =
        Table.Sort(
            Combined,
            {
                {"Domain",        Order.Ascending},
                {"MxTimeRecorded", Order.Descending}
            }
        ),

    // 5) De-duplicate to keep only one row per Domain (newest)
    Deduped =
        Table.Distinct(
            Sorted,
            {"Domain"}
        ),

    // 6) Ensure final types are correct for tblMxCache
    CacheForTable =
        Table.TransformColumnTypes(
            Deduped,
            {
                {"Domain",        type text},
                {"MxCommand",     type text},
                {"MxReputation",  type any},
                {"MxTimeRecorded", type datetime}
            }
        )
in
    CacheForTable