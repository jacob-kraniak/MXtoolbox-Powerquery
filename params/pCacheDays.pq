/*
==============================================================================
 Parameter Name : pCacheDays
 SOAR Stage    : SOAR 1 – Cache Control
 Type          : Number
 Required      : Yes
 Purpose       : Define the maximum age (in days) for cached MXToolbox
                 lookup results before a fresh API call is required.
 Used By       :
   - fnMxLookupWithCache
 Guardrails    :
   - Must be a non-negative integer
   - Larger values reduce API calls but increase data staleness
==============================================================================
*/

false meta [IsParameterQuery=true, Type="Logical", IsParameterQueryRequired=true]
