/*
==============================================================================
 Query Name : q_MxRunLog_NewRows
 SOAR Stage : SOAR 1 – Run Log Collector
 Load To    : Connection Only
 Purpose    : Produce log rows for the current run. No persistence occurs here.
==============================================================================
*/
let
    /* Example: log that cache update ran (extend later with per-row status) */
    Row =
        [
            RunID        = pRunID,
            EventUTC     = DateTime.UtcNow(),
            Stage        = "SOAR1",
            Domain       = null,
            MxCommand    = null,
            Action       = "CACHE_UPDATE_START",
            Status       = "OK",
            ErrorMessage = null,
            ErrorDetail  = null
        ],

    Output =
        #table(
            Record.FieldNames(Row),
            { Record.FieldValues(Row) }
        ),

    /* Enforce schema */
    ContractCols = Table.ColumnNames(q_MxRunLogSchema_Contract),

    SchemaFieldRecord =
        Type.RecordFields(Type.TableRow(Value.Type(q_MxRunLogSchema_Contract))),

    TypeMap =
        List.Transform(
            Record.FieldNames(SchemaFieldRecord),
            (c) => { c, Record.Field(SchemaFieldRecord, c)[Type] }
        ),

    Typed =
        Table.TransformColumnTypes(Output, TypeMap),

    Final =
        Table.SelectColumns(Typed, ContractCols, MissingField.UseNull)
in
    Final