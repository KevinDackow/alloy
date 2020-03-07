open user
open bool
/*
// File Permissions based on standard Linux permission bits
sig PermissionsObject {
	owner: one User,
	grp: one Group,
	ownerRWX: one RWXObject,
	grpRWX: one RWXObject,
	publicRWX: one RWXObject
}

// DO THIS

abstract sig RWX {}
one sig Read, Write, Execute extends RWX {}
abstract sig OGP {}
one sig OwnerPerm, GroupPerm, PublicPerm extends OGP {}

sig State {
	permissions: File -> OGP -> RWX 
}

s.permissions[f]
*/
