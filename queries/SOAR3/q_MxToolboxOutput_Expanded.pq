/*
==============================================================================
 Query Name : q_MxToolboxOutput_Expanded
 SOAR Stage : SOAR 3 – Detail Expansion & Enrichment
 Load To    : Connection Only
 Expansion  : LISTS / RECORDS (Intentional)
 Purpose    : Expand MXToolbox per-check detail objects for analyst
              investigation and enrichment workflows.
 Guardrails :
   - NOT for reporting or dashboards
   - May contain lists, records, and verbose detail
==============================================================================
*/
let
    Source = q_MxToolboxOutput_Raw,

    Expanded =
        Table.AddColumn(
            Source,
            "MxDetails",
            each [MxToolboxOutput_Raw],
            type record
        )
in
    Expanded