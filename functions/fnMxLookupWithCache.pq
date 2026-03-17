// fnMxLookupWithCache
// Wrapper around fnMxToolboxLookup that:
//  - Uses a limited cache table (Domain, MxCommand, MxReputation, MxTimeRecorded)
//  - Checks cache by Domain only (domain-level TTL)
//  - Applies a small delay before live API calls to respect rate limiting.

(domain as text, command as text) as table =>
let
    // 1) Load limited cache
    Cache = qMxResultsCache,

    // 2) Compute TTL cutoff for cache freshness
    NowLocal = DateTime.LocalNow(),
    Cutoff   = NowLocal - #duration(pCacheDays, 0, 0, 0),

    // 3) Filter cache to fresh rows for this domain (Domain-level key)
    CacheFreshForDomain =
        Table.SelectRows(
            Cache,
            each
                [Domain] = domain
                and [MxTimeRecorded] >= Cutoff
        ),

    Result =
        if Table.RowCount(CacheFreshForDomain) > 0 then
            // Cache HIT: return the cached row(s)
            CacheFreshForDomain
        else
            // Cache MISS: perform live MXToolbox lookup with rate-limited delay
            let
                // Rate-limit delay (pMinDelayMs is in milliseconds)
                DelayDuration =
                    #duration(
                        0, // days
                        0, // hours
                        0, // minutes
                        Number.From(pMinDelayMs) / 1000 // seconds
                    ),

                // Call the underlying MXToolbox function after the delay
                RawResult =
                    Function.InvokeAfter(
                        () => fnMxToolboxLookup(domain, command),
                        DelayDuration
                    ),

                // Project RawResult to the limited schema expected by tblMxCache
                // Adjust column names if your MXToolbox output differs.
                LimitedResult =
                    let
                        // Try to select the standard MXToolbox columns first
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
                                // Fallback: assume RawResult already matches the limited schema
                                RawResult,

                        Renamed =
                            Table.RenameColumns(
                                Selected,
                                {
                                    {"MxToolbox Output.Domain",      "Domain"},
                                    {"MxToolbox Output.Command",     "MxCommand"},
                                    {"MxToolbox Output.MxRep",       "MxReputation"},
                                    {"MxToolbox Output.TimeRecorded","MxTimeRecorded"}
                                },
                                MissingField.Ignore
                            )
                    in
                        Renamed
            in
                LimitedResult
in
    Result