open bool
open user
open filesystem
// This file contains our SQL server
sig Password {}
sig MySQLUser {}
abstract sig MySQLPriv {}
one sig FILE, SELECT, INSERT, UPDATE, DELETE. GRANT, DROP extends MySQLPriv {}

sig MySQLServerConf {
	user: User, -- The user who is running MySQL serverthe MySQL server has the same FS permissions as this user.
	local_infile: bool, -- if True, then a SQLUser can read any local file that the SQLServer can read
	secure_file_priv: Dir, -- restricts FILE permissions granted to MySQL users to only operate on files in this directory
}

sig MySQLServer {
	data: Dir, -- the directory where all MySQLServer data is stored
	config: one MySQLServerConf,
	user_accounts: MySQLUser -> one Password, -- each User has or does not have a password.
	privs: MySQLUser -> MySQLPriv		-- each User has a set of privileges
}

