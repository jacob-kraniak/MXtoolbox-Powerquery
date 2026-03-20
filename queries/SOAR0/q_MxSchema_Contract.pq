/*
==============================================================================
 Query Name : q_MxSchema_Contract
 SOAR Stage : SOAR 0 – Canonical Schema Contract
 Load To    : Not loaded
 Purpose    : Provide a value-based canonical schema table to avoid
              type/value leakage in downstream execution.
==============================================================================
*/

let
    SchemaType =
        type table [
            Domain              = text,
            MxCommand           = text,
            UID                 = text,
            CommandArgument     = text,
            MxRep               = any,
            DnsProvider         = any,
            ReportingNameServer = any,
            TimeRecorded        = any,
            TimeToComplete      = any,
            IsEndpoint          = any,
            HasSubscriptions    = any,
            FailedCount         = number,
            WarningsCount       = number,
            PassedCount         = number,
            TimeoutsCount       = number,
            FailedList          = list,
            WarningsList        = list,
            PassedList          = list,
            TimeoutsList        = list,
            HasDmarcRecord      = logical
        ],

    SchemaValue =
        #table(
            SchemaType,
            {}
        )
in
    SchemaValue