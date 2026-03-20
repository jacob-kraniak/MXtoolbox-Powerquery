/*
==============================================================================
 Query Name : q_MxRunLogSchema_Contract
 SOAR Stage : SOAR 0 – Log Schema Contract
 Load To    : Not loaded
 Purpose    : Canonical schema for persisted run logs (tblMxRunLog).
 Guardrails :
   - MUST remain a value-based empty table
   - MUST NOT reference Access/Excel
==============================================================================
*/
let
    SchemaType =
        type table [
            RunID        = text,
            EventUTC     = datetime,
            Stage        = text,
            Domain       = text,
            MxCommand    = text,
            Action       = text,
            Status       = text,
            ErrorMessage = text,
            ErrorDetail  = text
        ],
    SchemaValue = #table(SchemaType, {})
in
    SchemaValue