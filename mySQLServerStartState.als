open state
open mysqlserver

// Config file is the same across states
fact configFilesAreStatic {
	all s: State | {
		s.mysqlState.config = first.mysqlState.config
	}
}

// All users start with bad passwords
fact badPasswords {
	all u: MySQLUser | some bp: BadPassword | {
		first.mysqlState.server.user_accounts[u] = BadPassword
	}
}
