// fnMxLookupWithCache (fixed)
// Cache key is (Domain, MxCommand) instead of Domain-only.
(domain as text, command as text) as table =>
let
    Cache = q_MxResultsCache,
    NowLocal = DateTime.LocalNow(),
    Cutoff = NowLocal - #duration(pCacheDays, 0, 0, 0),

    CacheFresh =
        Table.SelectRows(
            Cache,
            each
                [Domain] = domain and
                [MxCommand] = command and
                [MxTimeRecorded] >= Cutoff
        ),

    Result =
        if Table.RowCount(CacheFresh) > 0 then
            CacheFresh
        else
            let
                DelayDuration =
                    #duration(0, 0, 0, Number.From(pMinDelayMs) / 1000),

                RawResult =
                    Function.InvokeAfter(
                        () => fnMxToolboxLookup(domain, command),
                        DelayDuration
                    ),

                // Project to cache schema
                Selected =
                    if Table.HasColumns(
                        RawResult,
                        {
                            "MxToolbox Output.Domain",
                            "MxToolbox Output.Command",
                            "MxToolbox Output.MxRep",
                            "MxToolbox Output.TimeRecorded"
                        }
                    )
                    then
                        Table.SelectColumns(
                            RawResult,
                            {
                                "MxToolbox Output.Domain",
                                "MxToolbox Output.Command",
                                "MxToolbox Output.MxRep",
                                "MxToolbox Output.TimeRecorded"
                            }
                        )
                    else
                        RawResult,

                Renamed =
                    Table.RenameColumns(
                        Selected,
                        {
                            {"MxToolbox Output.Domain", "Domain"},
                            {"MxToolbox Output.Command", "MxCommand"},
                            {"MxToolbox Output.MxRep", "MxReputation"},
                            {"MxToolbox Output.TimeRecorded", "MxTimeRecorded"}
                        },
                        MissingField.Ignore
                    )
            in
                Renamed
in
    Result