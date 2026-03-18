/*
==============================================================================
 Parameter Name : pUseNetworkLookups
 SOAR Stage    : SOAR 1 – Command Scope Control
 Type          : Logical
 Required      : Yes
 Purpose       : Enable or disable execution of Network-category MXToolbox
                 lookup commands (e.g., blacklist, smtp, tcp).
 Used By       :
   - q_MxCommandsActive
 Guardrails    :
   - Intended for future phases; default false for free-tier usage
==============================================================================
*/
false meta [IsParameterQuery=true, Type="Logical", IsParameterQueryRequired=true]