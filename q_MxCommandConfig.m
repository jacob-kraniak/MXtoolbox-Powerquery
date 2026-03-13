// q_MxCommandConfig
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
