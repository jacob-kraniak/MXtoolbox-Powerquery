// fnMxToolboxLookup
// Generic MXToolbox lookup: supports DNS commands (spf, dmarc, dkim, etc.)
// Returns a 1-row table with both scalar fields and list fields from MXToolbox.
(domain as text, command as text) as table =>
let
    // 1) Build URL based on the command
    //    Example (DMARC):
    //      https://api.mxtoolbox.com/api/v1/lookup/dmarc?argument=github.com
    BaseUrl = "https://api.mxtoolbox.com/api/v1/lookup/" & command,
    Url     = BaseUrl & "?" &
              Uri.BuildQueryString(
                  [ argument = domain ]
              ),

    // 2) Headers
    Headers = [
        Accept        = "application/json",
        Authorization = pMxApiKey
    ],

    // 3) Call the API
    Response = Web.Contents(
        Url,
        [
            Headers = Headers
        ]
    ),

    // 4) Parse JSON response
    Json = Json.Document(Response),

    // 5) Safely extract top-level scalar fields
    UIDVal              = try Json[UID]                  otherwise null,
    CommandArgumentVal  = try Json[CommandArgument]      otherwise domain,
    CommandValue        = try Json[Command]              otherwise command,
    MxRepValue          = try Json[MxRep]                otherwise null,
    DnsProviderVal      = try Json[DnsServiceProvider]   otherwise null,
    TimeRecordedVal     = try Json[TimeRecorded]         otherwise null,
    ReportingNSVal      = try Json[ReportingNameServer]  otherwise null,
    TimeToCompleteVal   = try Json[TimeToComplete]       otherwise null,
    IsEndpointVal       = try Json[IsEndpoint]           otherwise null,
    HasSubscriptionsVal = try Json[HasSubscriptions]     otherwise null,

    // 6) Handle list fields: Failed, Warnings, Passed, Timeouts
    FailedRaw   = try Json[Failed]   otherwise null,
    WarningsRaw = try Json[Warnings] otherwise null,
    PassedRaw   = try Json[Passed]   otherwise null,
    TimeoutsRaw = try Json[Timeouts] otherwise null,

    FailedList =
        if FailedRaw = null or not Value.Is(FailedRaw, type list)
        then {}
        else FailedRaw,

    WarningsList =
        if WarningsRaw = null or not Value.Is(WarningsRaw, type list)
        then {}
        else WarningsRaw,

    PassedList =
        if PassedRaw = null or not Value.Is(PassedRaw, type list)
        then {}
        else PassedRaw,

    TimeoutsList =
        if TimeoutsRaw = null or not Value.Is(TimeoutsRaw, type list)
        then {}
        else TimeoutsRaw,

    FailedCount   = List.Count(FailedList),
    WarningsCount = List.Count(WarningsList),
    PassedCount   = List.Count(PassedList),
    TimeoutsCount = List.Count(TimeoutsList),

    // 7) DMARC-specific convenience flag
    HasDmarcRecord =
        if Text.Lower(command) = "dmarc" then
            FailedCount = 0
        else
            null,

    // 8) Build output record (one row)
    //    Note: list-typed fields are included; they can be expanded later in PQ.
    OutputRecord = [
        UID              = UIDVal,
        Domain           = CommandArgumentVal,   // convenience alias
        Command          = CommandValue,
        CommandArgument  = CommandArgumentVal,
        MxRep            = MxRepValue,
        DnsProvider      = DnsProviderVal,
        ReportingNameServer = ReportingNSVal,
        TimeRecorded     = TimeRecordedVal,
        TimeToComplete   = TimeToCompleteVal,
        IsEndpoint       = IsEndpointVal,
        HasSubscriptions = HasSubscriptionsVal,

        FailedCount      = FailedCount,
        WarningsCount    = WarningsCount,
        PassedCount      = PassedCount,
        TimeoutsCount    = TimeoutsCount,

        FailedList       = FailedList,
        WarningsList     = WarningsList,
        PassedList       = PassedList,
        TimeoutsList     = TimeoutsList,

        HasDmarcRecord   = HasDmarcRecord
    ],

    OutputTable =
        #table(
            Record.FieldNames(OutputRecord),
            { Record.FieldValues(OutputRecord) }
        )
in
    OutputTable
