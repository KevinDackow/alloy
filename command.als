/* Representation of commands and processes. All functions you would
   type into the command line (e.g., usermod, see userStateTransitions
*/
abstract sig Command { }
-- all processes contain one command. This is an abstraction to simplify out multiprocessing
sig Process {
	cmd: one Command
}
