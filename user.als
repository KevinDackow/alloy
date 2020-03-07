/*
	This file contains signatures for Users and Groups, based on
	Linux standards.
	Some details:
		- Every User has a 'usergroup,' which is a group that only 
		that user is in. (Defined in userStartState.als)
		- Every User has a 'primary group,' which is the group it 
		is associated with by default. This starts off as the usergroup.
		(see https://www.networkworld.com/article/3409781/mastering-user-groups-on-linux.html)
*/
--------------------------------------
--- Users/Groups Sigs
--------------------------------------
// A User is analagous to a unique userid
sig User {
}
// A Groupis analagous to a unique groupid
sig Group {
}
// There must be a root Group and a root User
one sig RootGroup extends Group { }
one sig RootUser extends User { }
