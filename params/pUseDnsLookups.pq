/*
==============================================================================
 Parameter Name : pUseDnsLookups
 SOAR Stage    : SOAR 1 – Command Scope Control
 Type          : Logical
 Required      : Yes
 Purpose       : Enable or disable execution of DNS-category MXToolbox
                 lookup commands (e.g., SPF, DMARC, DKIM).
 Used By       :
   - q_MxCommandsActive
 Guardrails    :
   - When false, all DNS commands are excluded from execution
==============================================================================
*/
true meta [IsParameterQuery=true, Type="Logical", IsParameterQueryRequired=true]