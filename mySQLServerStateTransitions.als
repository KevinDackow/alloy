open mySQLServerStartState
// the function of a user granting another user privileges. For this to succeed,
// the caller must have the GRANT priv and the privilege they are granting. 
pred grant[caller, target: MySQLUser, targetPriv: MySQLPriv, before, after: State] {
	GRANT in before.mysqlState.server.privs[caller]
	targetPriv in before.mysqlState.server.privs[caller]
	after.usrGrpState.etcGroups[targetGroup] = before.usrGrpState.etcGroups[targetGroup] + targetUser
	// ensure the rest of the things remain the same.
	all u: User | {
 		after.usrGrpState.etcPasswd[u] = before.usrGrpState.etcPasswd[u]
	}
	all g: Group - targetGroup | {
 		after.usrGrpState.etcGroups[g] = before.usrGrpState.etcGroups[g]
	}
}
