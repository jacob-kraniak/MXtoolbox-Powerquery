/*
==============================================================================
 Query Name : qMxCacheUpdate
 SOAR Stage : SOAR 1 – Cache Maintenance
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Merge newly normalized SOAR 2 results into the persisted
              MXToolbox cache and retain the most recent entry per
              Domain + Command.
 Dependencies :
   - q_MxResultsCache
   - q_MxToolboxOutput
 Guardrails :
   - MUST NOT expand raw API output
   - Expects SOAR 2 scalar fields only
==============================================================================
*/

let
    Cache = q_MxResultsCache,

    // Adapt SOAR 2 output to cache schema
    Latest =
        Table.TransformColumns(
            q_MxToolboxOutput,
            {
                {"SenderDomain", each _, type text},
                {"MxCommand", each _, type text}
            }
        ),

    LatestForCache =
        Table.RenameColumns(
            Latest,
            {
                {"SenderDomain", "Domain"}
            }
        ),

    Combined =
        Table.Combine({Cache, LatestForCache}),

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