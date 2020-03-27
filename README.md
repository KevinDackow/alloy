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
The objective of this project is to model a MySQL Server. I have heavily referenced [this site](https://www.acunetix.com/websitesecurity/securing-mysql-server-ubuntu-16-04-lts/), which details common vulnerabilites in MySQL Server configurations. I have also used the MySQL [documentation](https://dev.mysql.com/). Please note that I am modeling a **version 8.0** MySQL Server.
### Server
I have created a signature which corresponds to a running MySQL Server. It contains information about users as well as a static configuration. The basic idea is that the MySQL Server is spun up with the provided configuration, and if we want to change the configuration we would have to restart the server, just like a real MySQL Server. The configuration and server sigs are represented here:

	sig MySQLServerConf {
		user: User,
		local_infile: bool,
		secure_file_priv: Dir,
	}

	sig MySQLServer {
		data: Dir,
		user_accounts: MySQLUser -> one Password,
		privs: MySQLUser -> MySQLPriv
	}

I will now explain why I included each of these specific components. First, note that there are two kinds of users: Linux Users and MySQL Users. Linux Users are traditional users on a Linux system (e.g., `root`, `kevin`), whereas MySQL Users are users *of the database*. I will always state in this portion of the document whether it is a MySQL User or Linux User.
#### Static Configuration
The sig `MySQLServerConf` is the initial configuration. These features are static once the server has started, as changes to them require a full restart. Instead of allowing for changes to these configurations, they are static, so once the solver creates a MySQLServerConf it cannot change across a trace of `State`s. However, no expressivity is lost, as a new trace with a different `MySQLServerConf` can represent restarting the server with a new config. Below are explanations for the fields of the sig:

* `user` - This is the *Linux* user who is the owner of the MySQL Server process.
* `local_infile` - This flag indicates what MySQL users with the `FILE` permission are allowed to access. If it is set to true, then a MySQL User (with `FILE` permission) is allowed to read any files on the computer that the Linux User who is running the MySQL Server process has read access to. If it is set to False, then MySQL Users are not allowed to read local files.
* `secure_file_priv` - A bit lighter weight than `local_infile=False`, this restricts the MySQL User to being able to read only files located within the specified directory.

#### Server State
The sig `MySQLServer` corresponds to dynamic, stateful components of a MySQL server. It can change throughout a single trace of `State`s. Here are explanations for the 

* `data` - A directory in the `FileSystem` which represents the [MySQL Data Directory](https://dev.mysql.com/doc/refman/8.0/en/data-directory.html). 
* `user_accounts` - Stores user accounts and passwords. For the sake of this project, I have assumed that unset/default passwords are necessarily unsecure, while passwords set by the user are necessarily secure, unless it is not unique. (E.g., if user1 and user2 both have the same password, user2 can sign into user1)
* `privs` - The MySQL Privileges that a MySQL User has.

### SQLi
I will define that a SQL Injection attack is successful iff an external user is able to access files which should not be accessible to a non-privileged MySQL *or* Linux user. That is, by default, we will say that anyone on the web should be able to access exacly one thing: the data in the database, or, in our model, the `data` field of the `MySQLServer`. If a malicious actor is able to access anything else, then we have a vulnerability.