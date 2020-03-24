/*
This files contains two parts:
	1) All valid state transitions.
	2) Test to ensure the state transitions are independent of one another
	3) Tests from all other files.

	Valid state transitions are represented by sigs.

	An important note:
		All valid state transition sigs must advance state such that all other state 
		information remains the same . Additionally, state transition functions
		must enforce this behavior themselves for the State pieces which they modify. 
	  	This file only makes sure the other larger State pieces remains unchanged.
			AN EXAMPLE:
				if you call usermod, it will change the userGroupState. It is the responsibility of the
				usermod pred to ensure that every component of userGroupState remains the same
				which is supposed to, whereas it is the job of this file to ensure that the other State
				pieces, such as the fileSystemState, remain the same.
		The rationale of this is so that one does not need to modify every StateTransition file when one adds
		a new valid state transition elsewhere, and instead one only needs to edit this file.
*/
open userStateTransitions
open filesystemStateTransitions

---- VALID STATE TRANSITIONS ----
abstract sig validStateTransition {
	s, s': State, 
} {
	s' = s.next
}
// These predicates are so you can make sure only one state piece is changed
pred dontChangePermissions[s, s': State] {
	s'.permState = s.permState
}
pred dontChangeUsrGrpState[s, s': State] {
	s'.usrGrpState = s.usrGrpState
}
pred dontChangeFileSystem[s, s': State] {
	s'.fsState = s.fsState
}

// All Valid Transitions:
// usrGrp State Transitions
sig usermodStateTransition extends validStateTransition { } {
	usermod[User, User, Group, s, s']
	dontChangePermissions[s, s'] and dontChangeFileSystem[s, s']
}

// FileSystem StateTransitions
pred onlyChangeFS[s, s': State] {
	dontChangePermissions[s, s'] and dontChangeUsrGrpState[s, s']
}

sig moveStateTransition extends validStateTransition { } {
	moveStateful[FSObject, Dir, s, s']
	onlyChangeFS[s, s']
}

sig removeStateTransition extends validStateTransition { } {
	removeStateful[FSObject, s, s']
	onlyChangeFS[s, s']
}

sig removeAllStateTransition extends validStateTransition { } {
	removeAllStateful[Dir, s, s']
	onlyChangeFS[s, s']
}

---- ENSURING EXACTLY ONE VALID TRANSITION BETWEEN STATES ----
fact {
	all beforeState: State - last{
		one v: validStateTransition| {
			v.s = beforeState
			v.s' = beforeState.next
		}
	}
}

---- STATE TRANSITION PREDS ----
// Should fine at least one instance
pred canTransition {
	some validStateTransition
}

// true if more than one state piece changes in a state transition
pred transitionsNotIndependent {
	some before: State - last, after: before.next | {
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
					not ( -- if either condition below is true, then it was a valid transition, so we negate it 
						fsXORusrGrpXORperm or -- either exactly one changed or
						(not (usrGrpChange or permChange or fsChange)) -- nothing changed
					)
				}
			}
		}
	}
}

---- THIS FILE TESTS ---- 
// expected: Instance found.
run canTransition for 2 but exactly 1 usermodStateTransition
// expected: No instance found.
run transitionsNotIndependent

---- USER & GROUP TESTS ----
// from: userStartState.als
// 	expected: No counterexample found.
check moreGroupsThanUsersAlways
check sameNumberGroupsAndUsersInit
//	expected: No instance found.
run passwdGroupNotInGrpsFile
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
