open state
open mysqlserver

// Config file is the same across states
fact configFilesAreStatic {
	all s: State | {
		s.mysqlState.config = first.mysqlState.config
	}
}

// There exists a MySQL DATA directory.
pred initDataDir {
	one data: Dir | {
		data = first.mysqlState.server.data
		first.permState.permissions[data] = 
	}
}

pred 
