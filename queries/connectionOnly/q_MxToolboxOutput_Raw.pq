/*
==============================================================================
 Query Name : q_MxToolboxOutput_Raw
 SOAR Stage : SOAR 1 – API Invocation & Envelope Capture
 Load To    : Connection Only
 Expansion  : NONE (nested records/lists allowed but MUST NOT be expanded)
 Purpose    : Invoke MXToolbox API with caching and throttling and return
              raw response envelopes for downstream SOAR stages.
 Dependencies :
   - q_DomainCommandPairs
   - fnMxLookupWithCache
 Consumers :
   - q_MxToolboxOutput (SOAR 2)
 Guardrails :
   - DO NOT expand [MxToolbox Output] in SOAR 1
   - Any normalization or flattening belongs in SOAR 2+
==============================================================================
*/
let
    Source = q_DomainCommandPairs,
    TopPairs = Table.FirstN(Source, pMaxAPICalls),
    TopPairsBuffered = Table.Buffer(TopPairs),

    Invoked =
        Table.AddColumn(
            TopPairsBuffered,
            "MxToolbox Output",
            each fnMxLookupWithCache([SenderDomain], [Command.Command])
        )
in
    Invoked