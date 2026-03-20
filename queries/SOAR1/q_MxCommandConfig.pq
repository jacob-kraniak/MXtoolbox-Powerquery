/*
==============================================================================
 Query Name : q_MxCommandConfig
 SOAR Stage : SOAR 1 – Command Configuration Baseline
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Define the authoritative configuration table for all supported
              MXToolbox lookup commands, including category and enabled state.
 Dependencies :
   - None (static configuration table)
 Consumers :
   - q_MxCommandsActive
 Guardrails :
   - MUST remain a static, deterministic configuration source
   - No API calls or dynamic logic in this query
==============================================================================
*/

let
    // Core configuration table for all MXToolbox commands
    // You can toggle Enabled from the UI if you want finer control.
    CommandTable =
        #table(
            {"Command", "Category", "Enabled"},
            {
                // ----- DNS Lookup Types (free tier) -----
                {"mx",   "DNS", false},
                {"a",    "DNS", false},
                {"dns",  "DNS", false},
                {"spf",  "DNS", true},
                {"txt",  "DNS", false},
                {"soa",  "DNS", false},
                {"ptr",  "DNS", false},
                {"dmarc","DNS", true},
                {"dkim", "DNS", true},

                // ----- Network Lookup Types (future phase) -----
                {"blacklist", "Network", false},
                {"smtp",      "Network", false},
                {"tcp",       "Network", false},
                {"http",      "Network", false},
                {"https",     "Network", false},
                {"ping",      "Network", false},
                {"trace",     "Network", false}
            }
        ),
    #"Changed Type" = Table.TransformColumnTypes(CommandTable,{{"Enabled", type logical}})
in
    #"Changed Type"
