/*
	This file contains the single global state definition.
*/
open util/ordering[State]
open user
open filesystem
open mysqlserver 

sig UserGroupState {
	etcGroups: Group -> User, -- state of the /etc/groups file
	etcPasswd: User -> one Group -- state of the /etc/passwd file
}

sig FileSystemState {
	fs: one FileSystem,
	cwd: one Dir
}

sig PermissionsState {
	permissions: FSObject -> OGP -> RWX -- FSObject has owner/grp/pub permissions
}

sig MySQLServerState {
	config: one MySQLServerConf,
	server: one MySQLServer
}

sig State {
	usrGrpState: one UserGroupState,
	fsState: one FileSystemState,
	permState: one PermissionsState,
	mysqlState: one MySQLServerState
}

// Make sure that these state pieces actually exist
fact statePiecesExistWhenOwned {
	all ug: UserGroupState | some s: State {
		s.usrGrpState = ug
	}
	all fs: FileSystemState | some s: State {
		s.fsState = fs
	}
	all p: PermissionsState | some s: State {
		s.permState = p
	}
	all m: MySQLServerState | some s: State {
		s.mysqlState = m
	}
}
