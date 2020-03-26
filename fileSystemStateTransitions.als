open state
open filesystem
---- STATEFUL FILESYSTEM MODIFIERS ----
// true if the user has permission to modify the object f in the given state
pred permissionToModify[u: User, f: FSObject, s: State] {
	one perms: s.permState.permissions[f] | one grps: u.*(s.usrGrpState.etcGroups) {
		((f.owner = u) and (perms[OwnerPerm] = Write)) or  -- if the user is the owner and has write OR
		((f.grp in grps) and (perms[GroupPerm] = Write)) or -- if user is in group and it has write OR
		(perms[PublicPerm] = Write) 					 -- if the public has write, then we satisfy this predicate
	}
}

// Move x to directory d
pred moveStateful [x: FSObject, d: Dir, s, s': State] {
	move[s.fsState.fs, s'.fsState.fs, x, d]
}
pred moveWithPerm [u: User, x: FSObject, d: Dir, s, s': State] {
	permissionToModify[u, x, s] and moveStateful[x, d, s, s']
}

// Delete the file or directory x
pred removeStateful [x: FSObject, s, s': State] {
 	remove[s.fsState.fs, s'.fsState.fs, x]
}
pred removeWithPerm [u: User, x: FSObject, d: Dir, s, s': State] {
	permissionToModify[u, x, s] and removeStateful[x, s, s']
}

// Recursively delete the object x
pred removeAllStateful [x: FSObject, s, s': State] {
	removeAll[s.fsState.fs, s'.fsState.fs, x]
}
pred removeAllWithPerm [u: User, x: FSObject, d: Dir, s, s': State] {
	permissionToModify[u, x, s] and removeAllStateful[x, s, s']
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
