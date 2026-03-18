/*
==============================================================================
 Query Name : q_MxPipelineTelemetry_SOAR3
 SOAR Stage : SOAR 3 – Pipeline Telemetry
 Load To    : Enabled
 Expansion  : NONE
==============================================================================
*/
let
    Source = q_MxToolboxOutput_SOAR3,
    Cache  = q_MxResultsCache,

    DomainsInRun = List.Distinct(Source[SenderDomain]),
    DomainsInCache = List.Distinct(Cache[Domain]),

    DomainCount = List.Count(DomainsInRun),
    CacheHitCount = List.Count(List.Intersect({DomainsInRun, DomainsInCache})),
    CacheMissCount = DomainCount - CacheHitCount,

    CacheHitRatio =
        if DomainCount = 0 then 0
        else Number.Round(CacheHitCount / DomainCount, 3),

    CommandsPerDomain =
        List.Count(List.Distinct(Source[MxCommand])),

    EstimatedHttpsGetRequests =
        CacheMissCount * CommandsPerDomain,

    Telemetry =
        #table(
            type table [ Metric = text, Value = number ],
            {
                {"DomainCount", DomainCount},
                {"CacheHitCount", CacheHitCount},
                {"CacheMissCount", CacheMissCount},
                {"CacheHitRatio", CacheHitRatio},
                {"CommandsPerDomain", CommandsPerDomain},
                {"EstimatedHttpsGetRequests", EstimatedHttpsGetRequests},
                {"ConfiguredMaxApiCalls", Number.From(pMaxApiCalls)},
                {"ConfiguredCacheStalenessDays", Number.From(pCacheStalenessDays)}
            }
        )
in
    Telemetry