/*
==============================================================================
 Query Name : qMxCacheUpdate
 SOAR Stage : SOAR 1 – Cache Maintenance
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Merge new SOAR 2 scalar results into cache and retain the
              most recent entry per Domain + Command.
 Dependencies :
   - q_MxResultsCache_Seed
   - q_MxToolboxOutput
 Guardrails :
   - MUST NOT load to worksheet
   - MUST NOT expand raw API output
==============================================================================
*/
let
    // Existing cache (safe read)
    Cache =
        Table.Buffer(q_MxResultsCache_Seed),

    // Latest SOAR 2 output
    Latest =
        Table.TransformColumnTypes(
            q_MxToolboxOutput,
            {
                {"SenderDomain", type text},
                {"MxCommand", type text},
                {"MxTimeRecorded", type datetime}
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
        )
in
    Deduped