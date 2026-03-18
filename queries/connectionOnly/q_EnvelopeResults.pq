/*
==============================================================================
 Query Name : q_EnvelopeResults
 SOAR Stage : SOAR 1 – Raw Envelope Input
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Read raw message envelope results from the persisted Excel
              table used as the upstream source for sender domain extraction.
 Dependencies :
   - Excel.CurrentWorkbook() table: tbl_EnvelopeResults
 Consumers :
   - q_DomainList
 Guardrails :
   - MUST remain a simple table reader
   - No enrichment, no normalization beyond basic typing
==============================================================================
*/

let
    Source = Excel.CurrentWorkbook(){[Name="tbl_EnvelopeResults"]}[Content],
    #"Changed Type" = Table.TransformColumnTypes(Source, {{"SenderFromDomain", type text}})
in
    #"Changed Type"