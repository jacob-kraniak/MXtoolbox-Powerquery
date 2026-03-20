/*
==============================================================================
 Parameter Name : pDatabasePath
 SOAR Stage     : SOAR 1 – Data Source Configuration
 Type           : Text
 Required       : Yes
 Purpose        : Authoritative path to the Access database (.accdb) used as
                  the persistence layer for the pipeline.
==============================================================================
*/
"'~\DomainReputation.accdb'"
meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]