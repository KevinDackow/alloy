/*
This files contains two parts:
	1) All valid state transitions.
	2) Test to ensure the state transitions are independent of one another
	3) Tests from all other files.

	Valid state transitions are represented by sigs.

	An important note:
		All valid state transition sigs must advance state such that all other state 
		information remains the same . Additionally, state transition functions
		must enforce this behavior themselves for the sub-State components which they modify. 
	  	This file only makes sure the other larger sub-States remains unchanged.
			AN EXAMPLE:
				if you call usermod, it will change the userGroupState. It is the responsibility of the
				usermod pred to ensure that every component of userGroupState remains the same
				which is supposed to, whereas it is the job of this file to ensure that the other sub-State
				components, such as the fileSystemState, remain the same.
		The rationale of this is so that one does not need to modify every StateTransition file when one adds
		a new valid state transition elsewhere, and instead one only needs to edit this file.
*/
open userStateTransitions
open filesystemStateTransitions

---- VALID STATE TRANSITIONS ----
abstract sig validStateTransition {
	s: State, 
	s': State
}

// These predicates are so you can make sure only one sub state is changed
pred changeOnlyUsrGrp[s, s': State] {
	s.fsState = s'.fsState
	s.permState = s'.permState
}

pred changeOnlyFS[s, s': State] {
	s.usrGrpState = s'.usrGrpState
	s.permState = s'.permState
}

pred changeOnlyPerm[s, s': State] {
	s.usrGrpState = s'.usrGrpState
	s.fsState = s'.fsState
}

// The valid transitions
sig usermodStateTransition extends validStateTransition { } {
	// should only affect s.usrGrpState
	usermod[User, User, Group, s, s']
	changeOnlyUsrGrp[s, s']
}

sig moveStateTransition extends validStateTransition { } {
	moveStateful[FSObject, Dir, s, s']
	changeOnlyFS[s, s']
}

sig removeStateTransition extends validStateTransition { } {
	removeStateful[FSObject, s, s']
	changeOnlyFS[s, s']
}

sig removeAllStateTransition extends validStateTransition { } {
	removeAllStateful[Dir, s, s']
	changeOnlyFS[s, s']
}

---- ENSURING EXACTLY ONE VALID TRANSITION BETWEEN STATES ----
fact {
	all before: State, after: before.next {
		one v: validStateTransition| {
			v.s = before
			v.s' = after
		}
	}
}

---- STATE TRANSITION PREDS ----
// true if other sub-State components can change when you call usermod
pred transitionsNotIndependent {
	some before: State, after: before.next | {
		// this mess below is a representation of at most one clause being true. 
		// First, we XOR all possible changes. A change of a sub-State == (before.subComponent != after.subComponent)
		// If there is exactly one change, the first disjunct is true. Thus, the pred is correctly false.
		// If there are multiple changes. the first and second disjuncts are false. Thus, the pred is correctly true. 
		// If there are no changes, the second disjunct is true. Thus, the pred is correctly false.
		let fsChange = (before.fsState != after.fsState), 
			usrGrpChange = (before.usrGrpState != after.usrGrpState),
			permChange = (before.permState != after.permState) | {
			let fsXORusrGrp = (not (fsChange iff usrGrpChange)) | {
				let fsXORusrGrpXORperm = (not (fsXORusrGrp iff permChange)) | {
					fsXORusrGrpXORperm or 
					(before.fsState = after.fsState) and (before.usrGrpState = after.usrGrpState) -- no changes
				}
			}
		}
	}
}

---- THIS FILE TESTS ---- 
// expected: No instance found.
run transitionsNotIndependent 

---- USER & GROUP TESTS ----
// from: userStartState.als
// 	expected: No counterexample found.
check moreGroupsThanUsersAlways
check sameNumberGroupsAndUsersInit
//	expected: No instance found.
run userNotInPasswd
run userNotInGroupOnInit
run groupsNotDisjointOnInit
run groupSizeNotEqualOne
run rootGroupNoRootUser

// from: userStateTransitions.als
//	expected: No instance found.
run userCannotBeAddedToGroupByUserWithRootPrivileges
run userAddedToGroupByUserWithoutRootPrivileges
run rootCannotAddToAllGroups

---- FILESYSTEM TESTS ----
// from: filesystemStateTransitions.als
// 	expected: No instance found.
run moveNotOkay
run removeNotOkay
run removeAllNotOkay
