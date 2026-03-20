/*
==============================================================================
 Function Name : fnMxLookup_Raw
 SOAR Stage    : SOAR 1 – Raw Lookup (PURE)
 Returns       : table (1 row; canonical schema)
 Purpose       : Perform MXToolbox lookup with no cache awareness and enforce
                 canonical schema contract using a safe type-map list.

 Dependencies  :
   - fnMxToolboxLookup
   - q_MxSchema_Contract

 Guardrails :
   - MUST NOT reference q_MxResultsCache
   - MUST enforce q_MxSchema_Contract using LIST mapping (not table type)
==============================================================================
*/
(domain as text, command as text) =>
let
    RawAny =
        fnMxToolboxLookup(domain, command),

    RawTable =
        if Value.Is(RawAny, type table) then
            RawAny
        else if Value.Is(RawAny, type record) then
            Table.FromRecords({ RawAny })
        else
            error "fnMxToolboxLookup returned unsupported type.",

    CanonicalOne =
        Table.FirstN(RawTable, 1),

    /* Build a valid TransformColumnTypes mapping from q_MxSchema_Contract */
    SchemaFieldRecord =
        Type.RecordFields(
            Type.TableRow(
                Value.Type(q_MxSchema_Contract)
            )
        ),

    FullTypeMap =
        List.Transform(
            Record.FieldNames(SchemaFieldRecord),
            (colName) => { colName, Record.Field(SchemaFieldRecord, colName)[Type] }
        ),

    /* Only apply types for columns that actually exist in this table */
    PresentCols =
        Table.ColumnNames(CanonicalOne),

    TypeMapFiltered =
        List.Select(
            FullTypeMap,
            (pair) => List.Contains(PresentCols, pair{0})
        ),

    EnforcedSchema =
        Table.TransformColumnTypes(
            CanonicalOne,
            TypeMapFiltered
        )
in
    EnforcedSchema