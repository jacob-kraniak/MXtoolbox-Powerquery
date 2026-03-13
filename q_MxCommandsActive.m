// q_MxCommandsActive
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
