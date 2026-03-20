/*
==============================================================================
 Query Name : q_MxResultsCache_Seed
 SOAR Stage : SOAR 1 – Cache Seed (Authoritative Reader)
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Safely read persisted MXToolbox cache data from Access and
              enforce canonical cache schema on every refresh.

 Dependencies :
   - q_AccessSource
   - q_MxCacheSchema_Contract
   - Access table: tblMxCache

 Guardrails :
   - MUST NOT reference Excel.CurrentWorkbook
   - MUST NOT reference q_MxResultsCache
   - MUST enforce cache schema regardless of Access state
==============================================================================
*/
let
    /* 1) Read Access table (or fallback to empty contract table) */
    RawCache =
        try
            q_AccessSource{[Name = "tblMxCache", Kind = "Table"]}[Data]
        otherwise
            null,

    CacheBase =
        if RawCache = null then
            q_MxCacheSchema_Contract
        else
            RawCache,

    /* 2) Normalize column names (trim whitespace only) */
    NormalizedNames =
        Table.TransformColumnNames(
            CacheBase,
            each Text.Trim(_)
        ),

    /* 3) Canonicalize names case-insensitively into contract names */
    RequiredColumns =
        Table.ColumnNames(q_MxCacheSchema_Contract),

    ExistingColumns =
        Table.ColumnNames(NormalizedNames),

    RenamePairs =
        List.RemoveNulls(
            List.Transform(
                ExistingColumns,
                (c) =>
                    let
                        match =
                            List.First(
                                List.Select(
                                    RequiredColumns,
                                    (r) => Text.Lower(r) = Text.Lower(c)
                                ),
                                null
                            )
                    in
                        if match <> null and match <> c then { c, match } else null
            )
        ),

    Canonicalized =
        if List.Count(RenamePairs) > 0 then
            Table.RenameColumns(NormalizedNames, RenamePairs, MissingField.Ignore)
        else
            NormalizedNames,

    /* 4) Ensure all required columns exist (add missing as nulls) */
    WithAllColumns =
        List.Accumulate(
            RequiredColumns,
            Canonicalized,
            (state, col) =>
                if Table.HasColumns(state, col) then
                    state
                else
                    Table.AddColumn(state, col, each null)
        ),

    /* 5) Build TransformColumnTypes mapping from contract (correct record access) */
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

    /* 6) Apply types + final projection */
    CacheTyped =
        Table.TransformColumnTypes(
            WithAllColumns,
            CacheTypeMap
        ),

    CacheFinal =
        Table.SelectColumns(
            CacheTyped,
            RequiredColumns,
            MissingField.UseNull
        )
in
    CacheFinal