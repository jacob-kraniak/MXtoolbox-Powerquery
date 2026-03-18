/*
==============================================================================
 Query Name : q_MxCommandsActive
 SOAR Stage : SOAR 1 – Active Command Selection
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Filter MXToolbox command configuration based on category
              (DNS / Network) and user-enabled switches to determine
              which lookup commands are active for execution.
 Dependencies :
   - q_MxCommandsConfig
   - pUseDnsLookups
   - pUseNetworkLookups
 Consumers :
*/
let
    Source = q_MxCommandsConfig,

    // Filter by DNS / Network switches
    FilteredByCategory =
        Table.SelectRows(
            Source,
            each
                (
                    [Category] = "DNS"     and pUseDnsLookups
                )
                or
                (
                    [Category] = "Network" and pUseNetworkLookups
                )
        ),

    // Keep only rows the user has Enabled
    FilteredEnabled =
        Table.SelectRows(FilteredByCategory, each ([Enabled] = true))
in
    FilteredEnabled