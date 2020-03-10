open state
open filesystem
---- BASIC FUNCTIONS, STATELESS ----
// Move x to directory d
pred moveStateful [x: FSObject, d: Dir, s, s': State] {
	move[s.fsState.fs, s'.fsState.fs, x, d]
}

// Delete the file or directory x
pred removeStateful [x: FSObject, s, s': State] {
 	remove[s.fsState.fs, s'.fsState.fs, x]
}

// Recursively delete the object x
pred removeAllStateful [x: FSObject, s, s': State] {
	removeAll[s.fsState.fs, s'.fsState.fs, x]
}

---- TESTS  ----
// Moving doesn't add or delete any file system objects
pred moveNotOkay {
	some before: State, after: before.next, x: FSObject, d:Dir | {
   		moveStateful[x, d, before, after]
    		before.fsState.fs.live != after.fsState.fs.live
	}
}

// remove does not remove exactly the specified file or directory
pred removeNotOkay {
	some before: State, after: before.next, x: FSObject | {
   		removeStateful[x, before, after]
    		after.fsState.fs.live != before.fsState.fs.live - x
	}
}

// removeAll removes exactly the specified subtree
pred removeAllNotOkay {
	some before: State, after: before.next, d: Dir | {
   		removeAllStateful[d, before, after]
		after.fsState.fs.live != before.fsState.fs.live - d.*(before.fsState.fs.contents)
	}
}
