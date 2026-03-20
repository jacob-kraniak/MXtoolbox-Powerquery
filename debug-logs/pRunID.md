/*
==============================================================================
 Parameter Name : pRunID
 SOAR Stage     : SOAR 1 – Run Correlation
 Type           : Text
 Required       : Yes
 Purpose        : Unique identifier for the current refresh/run.
 Notes          : Uses UTC timestamp string (stable enough for run grouping).
==============================================================================
*/
Text.From(DateTime.UtcNow())
meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]