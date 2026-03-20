/*
==============================================================================
 Query Name : q_AccessSource
 SOAR Stage : SOAR 1 – Data Source Configuration
 Load To    : Not loaded
 Expansion  : NONE
 Purpose    : Centralized, reusable Access database source. Provides a single
              authoritative OLE DB connection for all Access-backed queries.

 Dependencies :
   - Parameter: pDatabasePath

 Guardrails :
   - MUST NOT reference specific tables
   - MUST NOT perform transformations
   - MUST NOT reference Excel.CurrentWorkbook
==============================================================================
*/
let
    Source =
        OleDb.DataSource(
            "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & pDatabasePath & ";",
            [HierarchicalNavigation = true]
        )
in
    Source