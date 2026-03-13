let
    Cache   = qMxResultsCache,
    Latest  = q_MxToolboxOutput,   // after using cache-aware version

    Combined = Table.Combine({Cache, Latest}),

    // De‑dupe by Domain + Command, keep latest TimeRecorded
    Sorted = Table.Sort(Combined, {{"TimeRecorded", Order.Descending}}),

    Deduped =
        Table.Distinct(
            Sorted,
            {"Domain", "Command"}
        )
in
    Deduped
