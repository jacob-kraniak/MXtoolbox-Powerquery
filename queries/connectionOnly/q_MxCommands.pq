/*
==============================================================================
 Query Name : q_MxCommands
 SOAR Stage : SOAR 1 – Command List Projection
 Load To    : Connection Only
 Expansion  : NONE
 Purpose    : Project the active MXToolbox commands into a simple list
              used for downstream domain/command pairing logic.
 Dependencies :
   - q_MxCommandsActive
 Consumers :
   - q_DomainCommandPairs
 Guardrails
*/

let
    Source   = q_MxCommandsActive,
    Commands = Source[Command]   // returns a list like {"mx","a","spf"}
in
    Commands