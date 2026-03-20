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

    DomainsInRun =
        List.Distinct(Source[SenderDomain]),

    DomainsInCache =
        if Table.RowCount(Cache) = 0 then
            {}
        else
            List.Distinct(Cache[Domain]),

    DomainCount =
        List.Count(DomainsInRun),

    CacheHitCount =
        List.Count(List.Intersect({DomainsInRun, DomainsInCache})),

    CacheMissCount =
        DomainCount - CacheHitCount,

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
                {"ConfiguredMaxApiCalls", try Number.From(pMaxAPICalls) otherwise 0},
                {"ConfiguredCacheStalenessDays", try Number.From(pCacheDays) otherwise 0}
            }
        )
in
    Telemetry