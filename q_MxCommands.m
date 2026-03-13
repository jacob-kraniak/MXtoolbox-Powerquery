// q_MxCommands
let
    Source   = q_MxCommandsActive,
    Commands = Source[Command]   // returns a list like {"mx","a","spf"}
in
    Commands
