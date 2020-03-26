open mySQLServerStartState

// Changing a MySQLUser's password (automatically sets it to a GoodPassword, though this may still be vulnerable!
pred changeMySQLUserPassword[u: MySQLUser, before, after: State] {
	some pw: GoodPassword | {
		after.mysqlState.server.user_accounts[u] = pw
	}
}

// the function of a user granting another user privileges. For this to succeed,
// the caller must have the GRANT priv and the privilege they are granting. 
pred grant[caller, target: MySQLUser, targetPriv: MySQLPriv, before, after: State] {
	GRANT in before.mysqlState.server.privs[caller]
	targetPriv in before.mysqlState.server.privs[caller]
	targetPriv in after.mysqlState.server.privs[target]
}

// same as grant, but revokes the privilege instead.
pred revoke[caller, target: MySQLUser, targetPriv: MySQLPriv, before, after: State] {
	GRANT in before.mysqlState.server.privs[caller]
	targetPriv in before.mysqlState.server.privs[caller]
	targetPriv not in after.mysqlState.server.privs[target]
}
