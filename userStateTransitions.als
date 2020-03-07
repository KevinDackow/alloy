open userStartState
--------------------------------------
--- usermod: Adding User To Group
--------------------------------------
// the functionality of calling usermod -a -G targetGroup targetUser
pred usermod[caller, targetUser: User, targetGroup: Group, before, after: State] {
	caller in before.etcGroups[RootGroup] => 
		// perform usermod iff caller has root permissions
		after.etcGroups[targetGroup] = before.etcGroups[targetGroup] + targetUser
	else {
		// ensure the targetGroup doesn't change
		before.etcGroups[targetGroup] = after.etcGroups[targetGroup]
	}
	// ensure the rest of the things remain the same.
	all u: User | {
 		before.etcPasswd[u] = after.etcPasswd[u]
	}
	all g: Group - targetGroup | {
 		before.etcGroups[g] = after.etcGroups[g]
	}
}


--------------------------------------
--- usermod tests. Expected: No instance found.
--------------------------------------
// true if root privleged users cannot add other users to groups
pred userCannotBeAddedToGroupByUserWithRootPrivileges {
	some rootPriv, target: User | some before: State, after: before.next | some targetGroup: Group | {
		rootPriv in before.etcGroups[RootGroup]
		usermod[rootPriv, target, targetGroup, before, after]
		target not in after.etcGroups[targetGroup]
	}
}

// true if user without root can add users to groups
pred userAddedToGroupByUserWithoutRootPrivileges {
	some noRootPriv, target: User | some before: State, after: before.next | some targetGroup: Group | {
		noRootPriv not in before.etcGroups[RootGroup]
		target not in before.etcGroups[targetGroup]
		usermod[noRootPriv, target, targetGroup, before, after]
		target in after.etcGroups[targetGroup]
	}
}

// true if user with root cannot add users to every group
pred rootCannotAddToAllGroups {
	some rootPriv, target: User | some before: State, after: before.next | all targetGroup: Group | {
		rootPriv in before.etcGroups[RootGroup]
		target not in before.etcGroups[targetGroup]
		usermod[rootPriv, target, targetGroup, before, after]
		target not in after.etcGroups[targetGroup]
	}
}

run userCannotBeAddedToGroupByUserWithRootPrivileges
run userAddedToGroupByUserWithoutRootPrivileges
run rootCannotAddToAllGroups
