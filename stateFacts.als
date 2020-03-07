/*
This files contains two parts:
	1) All valid state transitions.
	2) All tests
*/
open userStateTransitions
fact {
	all s: State, s':  s.next {
		usermod[User, User, Group, s, s']
	}
}

---- USER & GROUP TESTS ----

// userStartState.als
-- expected: No counterexample found.
check moreGroupsThanUsersAlways
check sameNumberGroupsAndUsersInit
-- expected: No instance found.
run userNotInPasswd
run userNotInGroupOnInit
run groupsNotDisjointOnInit
run groupSizeNotEqualOne
run rootGroupNoRootUser

// userStateTransitions.als
-- expected: No instance found.
run userCannotBeAddedToGroupByUserWithRootPrivileges
run userAddedToGroupByUserWithoutRootPrivileges
run rootCannotAddToAllGroups
