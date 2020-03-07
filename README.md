# An Alloy representation of a MySQL server.
## Structure
The files are organized as follows:
`<module_name>.als`:\
	- contain the different sigs and facts pertaining to stateless invariants for the modules.

`<module_name>StartState.als`:\
	- contains the relevant start state setup & requirements for each module

`<module_name>StateTransitions.als`:\
	- contains the relevant state transition functionality for each module

`state.als`:\
	- defines global state setup. Any files dealing with state must import this module.
