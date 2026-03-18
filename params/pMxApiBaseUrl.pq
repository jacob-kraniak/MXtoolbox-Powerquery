/*
==============================================================================
 Parameter Name : pMxApiBaseUrl
 SOAR Stage    : SOAR 1 – API Configuration
 Type          : Any (Text)
 Required      : Yes
 Purpose       : Define the base URL for MXToolbox REST API lookups.
                 Centralizes endpoint configuration for portability.
 Used By       :
   - fnMxToolboxLookup
 Guardrails    :
   - Must point
*/

"https://api.mxtoolbox.com/api/v1/Lookup" meta [IsParameterQuery=true, Type="Any", IsParameterQueryRequired=true]