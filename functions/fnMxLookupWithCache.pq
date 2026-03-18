/*
==============================================================================
 Function Name : fnMxLookupWithCache
 SOAR Stage    : SOAR 1 – Cached Lookup Gate (No Expansion)
 Returns       : table (1 row; stable schema matching fnMxToolboxLookup)
 Purpose       : Return freshest cached lookup for (Domain, Command). If cache
                 is stale/missing, invoke fnMxToolboxLookup with delay.
                 Always return a single-row table with the canonical schema.
 Dependencies  :
   - q_MxResultsCache
   - fnMxToolboxLookup
   - pCacheDays
   - pMinDelayMs
 Guardrails    :
   - MUST NOT expand list fields
   - MUST return stable canonical schema every time
==============================================================================
*/

(domain as text, command as text) as table =>
let
    DomainNorm  = Text.Lower(Text.Trim(domain)),
    CommandNorm = Text.Lower(Text.Trim(command)),

    Cache    = q_MxResultsCache,
    NowLocal = DateTime.LocalNow(),
    Cutoff   = NowLocal - #duration(Number.From(pCacheDays), 0, 0, 0),

    CacheFreshAll =
        Table.SelectRows(
            Cache,
            each
                Text.Lower(Text.Trim(Text.From([Domain]))) = DomainNorm and
                Text.Lower(Text.Trim(Text.From([MxCommand]))) = CommandNorm and
                (try DateTime.From([MxTimeRecorded]) >= Cutoff otherwise false)
        ),

    CacheFreshOne =
        Table.FirstN(
            Table.Sort(CacheFreshAll, {{"MxTimeRecorded", Order.Descending}}),
            1
        ),

    // Canonical column set = fnMxToolboxLookup output columns
    CanonicalColumns = {
        "UID","Domain","Command","CommandArgument","MxRep","DnsProvider","ReportingNameServer",
        "TimeRecorded","TimeToComplete","IsEndpoint","HasSubscriptions",
        "FailedCount","WarningsCount","PassedCount","TimeoutsCount",
        "FailedList","WarningsList","PassedList","TimeoutsList","HasDmarcRecord"
    },

    FromCacheToCanonical =
        let
            // Map cache row into canonical schema; list fields default to {}
            CacheMapped =
                Table.AddColumn(
                    CacheFreshOne,
                    "Canonical",
                    each [
                        UID                 = null,
                        Domain              = [Domain],
                        Command             = [MxCommand],
                        CommandArgument     = [Domain],
                        MxRep               = [MxReputation],
                        DnsProvider         = null,
                        ReportingNameServer = null,
                        TimeRecorded        = [MxTimeRecorded],
                        TimeToComplete      = null,
                        IsEndpoint          = null,
                        HasSubscriptions    = null,

                        FailedCount         = null,
                        WarningsCount       = null,
                        PassedCount         = null,
                        TimeoutsCount       = null,

                        FailedList          = {},
                        WarningsList        = {},
                        PassedList          = {},
                        TimeoutsList        = {},

                        HasDmarcRecord      = null
                    ],
                    type record
                ),

            CanonicalExpanded =
                Table.ExpandRecordColumn(
                    CacheMapped,
                    "Canonical",
                    CanonicalColumns,
                    CanonicalColumns
                ),

            CanonicalOne =
                Table.FirstN(CanonicalExpanded, 1)
        in
            CanonicalOne,

    Result =
        if Table.RowCount(CacheFreshOne) > 0 then
            FromCacheToCanonical
        else
            let
                DelayDuration = #duration(0, 0, 0, Number.From(pMinDelayMs) / 1000),

                RawAny =
                    Function.InvokeAfter(
                        () => fnMxToolboxLookup(domain, command),
                        DelayDuration
                    ),

                RawTable =
                    if Value.Is(RawAny, type table) then
                        RawAny
                    else if Value.Is(RawAny, type record) then
                        Table.FromRecords({RawAny})
                    else
                        error "fnMxToolboxLookup returned unsupported type (expected table or record).",

                // Enforce canonical schema + 1 row
                CanonicalProjected =
                    Table.SelectColumns(RawTable, CanonicalColumns, MissingField.UseNull),

                CanonicalOne =
                    Table.FirstN(CanonicalProjected, 1)
            in
                CanonicalOne
in
    Result
