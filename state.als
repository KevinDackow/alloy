/*
	This file contains the single global state definition.
*/
open util/ordering[State]
open user
open filesystem

sig UserGroupState {
	etcGroups: Group -> User, -- state of the /etc/groups file
	etcPasswd: User -> one Group, -- state of the /etc/passwd file
}

sig FileSystemState {
	fs: FileSystem
}

sig ProcessesState {
}

sig State {
	usrGrpState: one UserGroupState,
	fsState: one FileSystemState
}
