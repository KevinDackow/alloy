# An Alloy representation of a MySQL server.
## Structure
The files are organized as follows:

`<module_name>.als`:

* contain the different sigs and facts pertaining to stateless invariants for the modules.

`<module_name>StartState.als`:

* contains the relevant start state setup & requirements for each module

`<module_name>StateTransitions.als`:

* contains the relevant state transition functionality for each module

`state.als`:

* defines global state setup. Any files dealing with state must import this module.

`stateFacts.als`:

* contains all predicates and signatures required to ensure state transitions are executed properly.

## MySQL Server
### Initial Comments
The bulk of this project is the MySQL Server. I have heavily referenced [this site](https://www.acunetix.com/websitesecurity/securing-mysql-server-ubuntu-16-04-lts/), which details common vulnerabilites in MySQL Server configurations. 
### Configuration
I have created a signature which contains the configuration of a MySQL Server. Here it is:

	one sig FILE, SELECT, INSERT, UPDATE, DELETE extends MySQLPriv {}
	
	sig MySQLServerConf {
		user: User,
		local_infile: bool, 
		secure_file_priv: Dir,
		user_accounts: MySQLUser -> one Password,
		privs: MySQLUser -> MySQLPriv
	}


I will now explain why I included each of these specific components. First, note that there are two kinds of users: Linux Users and MySQL Users. Linux Users are traditional users on a Linux system (e.g., `root`, `kevin`), whereas MySQL Users are users *of the database*. I will always state in this portion of the document whether it is a MySQL User or Linux User.

* `user` - This is the *Linux* user who is the owner of the MySQL Server process.
* `local_infile` - This flag indicates what MySQL users with the `FILE` permission are allowed to access. If it is set to true, then a MySQL User (with `FILE` permission) is allowed to read any files on the computer that the Linux User who is running the MySQL Server process has read access to. If it is set to False, then MySQL Users are not allowed to read local files.
* `secure_file_priv` - A bit lighter weight than `local_infile=False`, this restricts the MySQL User to being able to read only files located within the specified directory.
* `user_accounts` - Stores user accounts and passwords. For the sake of this project, I have assumed that unset/default passwords are necessarily unsecure, while passwords set by the user are necessarily secure.
* `privs` - The MySQL Privileges that a MySQL User has.

### SQLi
I will define that a SQL Injection attack is successful iff an external user is able to access files which should not be accessible to a non-privileged MySQL *or* Linux user. That is, by default, we will say that anyone on the web should be able to access exacly one thing: the data in the database. If they are able to access anything else, without some dramatic error on the part of the sysadmin (e.g., giving an external user root privileges intentionally) then we have a vulnerability. 