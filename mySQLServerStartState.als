open state
open mysqlserver

// Config file is the same across states
fact configFilesAreStatic {
	all s: State | {
		s.mysqlState.config = first.mysqlState.config
	}
}
