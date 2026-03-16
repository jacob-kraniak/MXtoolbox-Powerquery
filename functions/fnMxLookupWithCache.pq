// fnMxLookupWithCache
// Wrapper around fnMxToolboxLookup that first checks qMxResultsCache (tblMxCache)
// to avoid reusing MXToolbox API calls for recent (Domain, Command) pairs.

(domain as text, command as text) as table =>
let
    // 1) Load current cache table (backed by tblMxCache via qMxResultsCache)
    Cache = qMxResultsCache,

    // 2) Optional TTL: only reuse rows newer than (now - pCacheDays)
    //    If you don't want TTL, set pCacheDays to a very large number or
    //    remove this block and just use CacheFilteredByKey = Cache.
    NowLocal = DateTime.LocalNow(),
    Cutoff   = NowLocal - #duration(pCacheDays, 0, 0, 0),

    CacheWithTime =
        if Table.HasColumns(Cache, {"TimeRecorded"})
        then
            Table.TransformColumns(
                Cache,
                {{"TimeRecorded", DateTime.From, type datetime}}
            )
        else
            Cache,

    CacheFresh =
        if Table.HasColumns(CacheWithTime, {"TimeRecorded"})
        then
            Table.SelectRows(
                CacheWithTime,
                each [TimeRecorded] >= Cutoff
            )
        else
            CacheWithTime,

    // 3) Filter cache by (Domain, Command)
    CacheFilteredByKey =
        Table.SelectRows(
            CacheFresh,
            each [Domain] = domain and [Command] = command
        ),

    // 4) If we have any fresh cached rows, use the *latest* one;
    //    otherwise call the live API function.
    Result =
        if Table.RowCount(CacheFilteredByKey) > 0 then
            let
                Sorted =
                    if Table.HasColumns(CacheFilteredByKey, {"TimeRecorded"})
                    then
                        Table.Sort(
                            CacheFilteredByKey,
                            {{"TimeRecorded", Order.Descending}}
                        )
                    else
                        CacheFilteredByKey,
                TopOne = Table.FirstN(Sorted, 1)
            in
                TopOne
        else
            fnMxToolboxLookup(domain, command)
in
    Result
