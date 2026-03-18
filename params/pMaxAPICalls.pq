/*
==============================================================================
 Parameter Name : pMaxAPICalls
 SOAR Stage    : SOAR 1 – Rate Limiting
 Type          : Number
 Required      : Yes
 Purpose       : Limit the maximum number of MXToolbox API calls executed
                 in a single refresh cycle to control cost and throttling.
 Used By       :
   - q_MxToolboxOutput_Raw
 Guardrails    :
   - Must be a positive integer
   - Applied before API invocation to bound workload size
==============================================================================
*/

5 meta [IsParameterQuery=true, Type="Number", IsParameterQueryRequired=true]