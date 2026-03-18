/*
==============================================================================
 Parameter Name : pMxApiKey
 SOAR Stage    : SOAR 1 – Authentication
 Type          : Any (Text)
 Required      : Yes
 Purpose       : Store the MXToolbox API key used to authenticate lookup
                 requests. Supports free-tier and paid keys.
 Used By       :
   - fnMxToolboxLookup
 Guardrails    :
*/
"<YOUR API KEY HERE>" meta [IsParameterQuery=true, Type="Any", IsParameterQueryRequired=true]
