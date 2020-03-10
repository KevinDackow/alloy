/*
This files contains two parts:
	1) All valid state transitions.
	2) All tests
*/
open userStateTransitions
---- VALID STATE TRANSITIONS ----
/*
	Valid state transitions are represented by predicates being met. 
	This section has two key things:
		1) All valid predicates to advance state such that all other state 
		    information remains the same (e.g., calling usermod shouldn't 
		    affect the filesystem's state). PLEASE NOTE - state transition functions
		    must enforce this behavior themselves for the sub-State (e.g., userGroupState)
		    components. This file only makes sure the other larger sub-States remain
 	 	    unchanged
		2) A fact which forces all state transitions to be one of these valid 
		    preds
*/

sig validStateTransition {
	s, s': State
}

sig usermodStateTransition extends validStateTransition { } {
	usermod[User, User, Group, s, s']
	s.@fsState = s'.@fsState
}

fact {
	all s: State, s':  s.next {
		one v: validStateTransition| {
			v.@s = s
			v.@s' =s'
		}
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
