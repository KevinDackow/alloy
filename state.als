/*
	This file contains the single global state definition.
*/
open util/ordering[State]
open user
open filesystem

sig State { 
	etcGroups: Group -> User, -- state of the /etc/groups file
	etcPasswd: User -> one Group, -- state of the /etc/passwd file
	fs: one Filesystem
}
