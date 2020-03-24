/*
	This file contains the single global state definition.
*/
open util/ordering[State]
open user
open filesystem

sig UserGroupState {
	etcGroups: Group -> User, -- state of the /etc/groups file
	etcPasswd: User -> one Group -- state of the /etc/passwd file
}

sig FileSystemState {
	fs: one FileSystem
}

sig PermissionsState {
	permissions: FSObject -> OGP -> RWX -- FSObject has owner/grp/pub permissions
}

sig State {
	usrGrpState: one UserGroupState,
	fsState: one FileSystemState,
	permState: one PermissionsState
}

// Make sure that these s
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
}
