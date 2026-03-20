/*
==============================================================================
 Query Name : q_MxCacheUpdate
 SOAR Stage : SOAR 1 – Cache Maintenance (Authoritative)
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Merge new SOAR 1 execution results into the persisted cache
              and retain the most recent entry per Domain × MxCommand.

 Dependencies :
   - q_MxResultsCache_Seed
   - q_MxToolboxOutput_Raw
   - q_MxCacheSchema_Contract

 Guardrails :
   - MUST NOT load to worksheet
   - MUST enforce cache schema contract on ALL inputs
   - MUST retain 1 row per Domain × MxCommand
   - MUST NOT expand list-valued API output
==============================================================================
*/
let
    /* -----------------------------------------------------------------------
       0) Contract columns + type map (MUST be a LIST for TransformColumnTypes)
       ----------------------------------------------------------------------- */
    ContractColumns =
        Table.ColumnNames(q_MxCacheSchema_Contract),

    CacheFieldRecord =
        Type.RecordFields(
            Type.TableRow(
                Value.Type(q_MxCacheSchema_Contract)
            )
        ),

    CacheTypeMap =
        List.Transform(
            Record.FieldNames(CacheFieldRecord),
            (colName) => { colName, Record.Field(CacheFieldRecord, colName)[Type] }
        ),

    /* -----------------------------------------------------------------------
       1) Existing persisted cache (Seed is already stable)
       ----------------------------------------------------------------------- */
    ExistingCache =
        Table.TransformColumnTypes(
            q_MxResultsCache_Seed,
            CacheTypeMap
        ),

    /* -----------------------------------------------------------------------
       2) Canonicalize latest output to Domain + MxCommand
          (defensive if upstream changed column names)
       ----------------------------------------------------------------------- */
    LatestRenamed =
        Table.RenameColumns(
            q_MxToolboxOutput_Raw,
            {
                {"SenderDomain", "Domain"},
                {"Command", "MxCommand"},
                {"MxToolbox Output.Domain", "Domain"},
                {"MxToolbox Output.Command", "MxCommand"}
            },
            MissingField.Ignore
        ),

    LatestProjected =
        Table.SelectColumns(
            LatestRenamed,
            {"Domain", "MxCommand"},
            MissingField.UseNull
        ),

    LatestFiltered =
        Table.SelectRows(
            LatestProjected,
            each [Domain] <> null and [Domain] <> "" and [MxCommand] <> null and [MxCommand] <> ""
        ),

    /* -----------------------------------------------------------------------
       3) Add cache metadata (UTC-by-convention)
       ----------------------------------------------------------------------- */
    LatestWithTimestamp =
        Table.AddColumn(
            LatestFiltered,
            "LastCheckedUTC",
            each DateTime.UtcNow(),
            type datetime
        ),

    LatestWithStatus =
        Table.AddColumn(
            LatestWithTimestamp,
            "CacheStatus",
            each "HIT",
            type text
        ),

    LatestWithRunId =
        Table.AddColumn(
            LatestWithStatus,
            "RunID",
            each Text.From(DateTime.UtcNow()),
            type text
        ),

    /* -----------------------------------------------------------------------
       4) Enforce schema BEFORE merge (prevents type widening)
       ----------------------------------------------------------------------- */
    LatestTyped =
        Table.TransformColumnTypes(
            LatestWithRunId,
            CacheTypeMap
        ),

    /* -----------------------------------------------------------------------
       5) Merge + deterministic latest-wins
       ----------------------------------------------------------------------- */
    Combined =
        Table.Combine({ExistingCache, LatestTyped}),

    Sorted =
        Table.Sort(
            Combined,
            {
                {"Domain", Order.Ascending},
                {"MxCommand", Order.Ascending},
                {"LastCheckedUTC", Order.Descending}
            }
        ),

    Deduped =
        Table.Distinct(
            Sorted,
            {"Domain", "MxCommand"}
        ),

    /* -----------------------------------------------------------------------
       6) Final projection + final type enforcement
       ----------------------------------------------------------------------- */
    CacheFinal =
        Table.SelectColumns(
            Deduped,
            ContractColumns,
            MissingField.UseNull
        ),

    CacheFinalTyped =
        Table.TransformColumnTypes(
            CacheFinal,
            CacheTypeMap
        )
in
    CacheFinalTyped