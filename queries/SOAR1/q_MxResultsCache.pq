/*
==============================================================================
 Query Name : q_MxResultsCache
 SOAR Stage : SOAR 1 – Persisted Cache Store
 Load To    : ENABLED (tblMxCache)
 Expansion  : NONE
 Purpose    : Authoritative persisted MXToolbox cache table.

 Guardrails :
   - MUST be the only query that loads tblMxCache
   - MUST NOT read tblMxCache directly (reader is q_MxResultsCache_Seed)
   - MUST output ONLY the cache schema contract columns
==============================================================================
*/
let
    Source =
        q_MxCacheUpdate,

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

    Projected =
        Table.SelectColumns(
            Source,
            ContractColumns,
            MissingField.UseNull
        ),

    Typed =
        Table.TransformColumnTypes(
            Projected,
            CacheTypeMap
        )
in
    Typed