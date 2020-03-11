open user
// Permissions for FSObjects
abstract sig RWX {}
one sig Read, Write, Execute extends RWX {}
abstract sig OGP {}
one sig OwnerPerm, GroupPerm, PublicPerm extends OGP {}
