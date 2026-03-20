/*
==============================================================================
 Query Name : q_EnvelopeResults
 SOAR Stage : SOAR 1 – Raw Envelope Input
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Read raw message envelope results from the persisted Access
              domain inventory used as the upstream source for sender
              domain extraction.
 Dependencies :
   - q_AccessSource
   - Access table: tblDomains
 Consumers :
   - q_DomainList
 Guardrails :
   - MUST remain a simple table reader
   - No enrichment, no normalization beyond basic typing
==============================================================================
*/

let
    Source =
        q_AccessSource,

    tblDomains_Table =
        Source{[Name = "tblDomains", Kind = "Table"]}[Data],

    #"Changed Type" =
        Table.TransformColumnTypes(
            tblDomains_Table,
            {{"SenderFromDomain", type text}}
        )
in
    #"Changed Type"