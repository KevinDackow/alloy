open bool
open user
// This file contains our SQL server
sig Password {}
sig MySQLUser {}
abstract sig MySQLPriv {}
abstract sig OGP {}
one sig FILE, SELECT, INSERT, UPDATE, DELETE extends MySQLPriv {}

sig MySQLServerConf {
	user: User, -- The user who is running MySQL serverthe MySQL server has the same FS permissions as this user.
	local_infile: bool, -- if True, then a SQLUser can read any local file that the SQLServer can read
	secure_file_priv: Dir, -- restricts FILE permissions granted to MySQL users to only operate on files in this directory
	user_accounts: MySQLUser -> one Password, -- each User has or does not have a password.
	privs: MySQLUser -> MySQLPriv,		-- each User has a set of privileges
	
}

