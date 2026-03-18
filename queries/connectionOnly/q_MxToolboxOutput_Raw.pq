// q_MxToolboxOutput_Raw (connection only)
// Removed Expansion Step - 03/18/26

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