/*
==============================================================================
 Query Name : q_MxLeadershipOutput
 SOAR Stage : SOAR 3 – Leadership Reporting View
 Load To    : Enabled
 Expansion  : NONE
 Purpose    : Produce a leadership-ready reporting dataset
              from SOAR‑3 scalar output.
 Dependencies :
   - q_MxToolboxOutput_SOAR3
==============================================================================
*/
let
    Source = q_MxToolboxOutput_SOAR3,

    Selected =
        Table.SelectColumns(
            Source,
            {
                "SenderDomain",
                "MxCommand",
                "MxReputation",
                "MxTimeRecorded",
                "FailedCount",
                "WarningsCount",
                "TimeoutsCount",
                "DnsProvider",
                "ReportingNameServer",
                "HasDmarcRecord"
            }
        )
in
    Selected