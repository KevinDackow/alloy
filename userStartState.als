open state
--------------------------------------
--- Start State
--------------------------------------
// Ensure the root user is in the root group.
fact initialState {
	first.etcPasswd[RootUser] = RootGroup
	first.etcGroups[RootGroup] = RootUser
	all u: User - RootUser | one newUsergroup: Group - RootGroup | {
		first.etcGroups[newUsergroup] = u
		first.etcPasswd[u] = newUsergroup
	}
	-- ensure all groups have exactly one member
	all g: Group | {
		one first.etcGroups[g]
	}
	-- ensure there are no superfluous groups
	#User = #Group
}

--------------------------------------
--- Invariants. Expected: No instance found.
--------------------------------------
// All users must have passwd entries
pred userNotInPasswd {
	some u: User | {
		no g: Group | {
			first.etcPasswd[u] = g
		} 
	}
}
// All users must be in at least one group initially
pred userNotInGroupOnInit {
	some u: User | {
		no grp: Group | {
			first.etcGroups[grp] = u
		}
	}
}
// All groups must have different users to start
pred groupsNotDisjointOnInit {
	some disj g1, g2: Group | {
		first.etcGroups[g1] = first.etcGroups[g2]
	}
}

// All groups must start with exactly one member
pred groupSizeNotEqualOne {
	some g: Group | {
		#first.etcGroups[g] != 1
	}
}

// RootGroup starts without RootUser or vice versa
pred rootGroupNoRootUser {
	first.etcGroups[RootGroup] != RootUser
	first.etcPasswd[RootUser] != RootGroup
}

--------------------------------------
--- Permanent Assertions
--------------------------------------
// Should be at least as many groups as users (1 user group per user, at minimum)
assert moreGroupsThanUsersAlways { #Group >= #User }
assert sameNumberGroupsAndUsersInit { #Group = #User }

--------------------------------------
--- Start State Tests
--------------------------------------
// if all users are in passwd
run userNotInPasswd
// all users are in one group
run userNotInGroupOnInit
// all groups are disjoint
run groupsNotDisjointOnInit
// and all groups have size 1
run groupSizeNotEqualOne
// and root is correct, then we know that each user is in exactly one usergroup to start
run rootGroupNoRootUser
