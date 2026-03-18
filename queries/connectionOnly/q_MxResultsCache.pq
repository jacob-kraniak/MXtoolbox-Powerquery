/*
==============================================================================
 Query Name : q_MxResultsCache
 SOAR Stage : SOAR 1 – Persisted Cache Reader (Breaks Cycles)
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Read persisted cache table (tblMxCache) and apply minimal
              normalization so cache keys match reliably.
 Dependencies :
   - Excel.CurrentWorkbook() table: tblMxCache
 Consumers :
   - fnMxLookupWithCache
 Guardrails :
   - No API calls and no expansions in this query
   - Only safe, deterministic transforms (types + trim/lower)
==============================================================================
*/

let
    Source = Excel.CurrentWorkbook(){[Name = "tblMxCache"]}[Content],

    #"Changed Type" =
        Table.TransformColumnTypes(
            Source,
            {
                {"Domain",         type text},
                {"MxCommand",      type text},
                {"MxReputation",   type any},
                {"MxTimeRecorded", type datetime}
            }
        ),

    #"Normalized Keys" =
        Table.TransformColumns(
            #"Changed Type",
            {
                {"Domain",    each Text.Lower(Text.Trim(_)), type text},
                {"MxCommand", each Text.Lower(Text.Trim(_)), type text}
            }
        )
in
    #"Normalized Keys"