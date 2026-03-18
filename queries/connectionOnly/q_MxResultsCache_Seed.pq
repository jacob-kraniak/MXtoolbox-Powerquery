/*
==============================================================================
 Query Name : q_MxResultsCache_Seed
 SOAR Stage : SOAR 1 – Cache Seed (Safe Reader)
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Safely read persisted MXToolbox cache data if it exists.
              Returns an empty, typed table when cache is missing.
 Guardrails :
   - MUST NOT load to worksheet
   - MUST NOT reference q_MxResultsCache
==============================================================================
*/
let
    Source =
        try
            Excel.CurrentWorkbook(){[Name = "tblMxCache"]}[Content]
        otherwise
            #table(
                type table [
                    Domain = text,
                    MxCommand = text,
                    MxReputation = any,
                    MxTimeRecorded = datetime
                ],
                {}
            ),

    Typed =
        Table.TransformColumnTypes(
            Source,
            {
                {"Domain", type text},
                {"MxCommand", type text},
                {"MxReputation", type any},
                {"MxTimeRecorded", type datetime}
            }
        )
in
    Typed