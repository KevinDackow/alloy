open userStartState
--------------------------------------
--- usermod: Adding User To Group
--------------------------------------
// the functionality of calling usermod -a -G targetGroup targetUser
pred usermod[caller, targetUser: User, targetGroup: Group, before, after: State] {
	caller in before.usrGrpState.etcGroups[RootGroup] => 
		// perform usermod iff caller has root permissions
		after.usrGrpState.etcGroups[targetGroup] = before.usrGrpState.etcGroups[targetGroup] + targetUser
	else {
		// ensure the targetGroup doesn't change
		before.usrGrpState.etcGroups[targetGroup] = after.usrGrpState.etcGroups[targetGroup]
	}
	// ensure the rest of the things remain the same.
	all u: User | {
 		before.usrGrpState.etcPasswd[u] = after.usrGrpState.etcPasswd[u]
	}
	all g: Group - targetGroup | {
 		before.usrGrpState.etcGroups[g] = after.usrGrpState.etcGroups[g]
	}
}


--------------------------------------
--- usermod tests. Expected: No instance found.
--------------------------------------
// true if root privleged users cannot add other users to groups
pred userCannotBeAddedToGroupByUserWithRootPrivileges {
	some rootPriv, target: User | some before: State, after: before.next | some targetGroup: Group | {
		rootPriv in before.usrGrpState.etcGroups[RootGroup]
		usermod[rootPriv, target, targetGroup, before, after]
		target not in after.usrGrpState.etcGroups[targetGroup]
	}
}

// true if user without root can add users to groups
pred userAddedToGroupByUserWithoutRootPrivileges {
	some noRootPriv, target: User | some before: State, after: before.next | some targetGroup: Group | {
		noRootPriv not in before.usrGrpState.etcGroups[RootGroup]
		target not in before.usrGrpState.etcGroups[targetGroup]
		usermod[noRootPriv, target, targetGroup, before, after]
		target in after.usrGrpState.etcGroups[targetGroup]
	}
}

// true if user with root cannot add users to every group
pred rootCannotAddToAllGroups {
	some rootPriv, target: User | some before: State, after: before.next | all targetGroup: Group | {
		rootPriv in before.usrGrpState.etcGroups[RootGroup]
		target not in before.usrGrpState.etcGroups[targetGroup]
		usermod[rootPriv, target, targetGroup, before, after]
		target not in after.usrGrpState.etcGroups[targetGroup]
	}
}

run userCannotBeAddedToGroupByUserWithRootPrivileges
run userAddedToGroupByUserWithoutRootPrivileges
run rootCannotAddToAllGroups
