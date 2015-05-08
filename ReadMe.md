### Setting Up the MySQL Database

If the administrator creates your database for you when setting up your permissions, you can begin using it. Otherwise, you need to create it yourself:
```sh
mysql> CREATE DATABASE homewsn;
```
Creating a database does not select it for use; you must do that explicitly. To make homewsn the current database, use this command:
```sh
mysql> USE homewsn
```
Execute the homewsn.sql script to create the database structure by using the following command:
```sh
mysql> SOURCE path/to/homewsn.sql;
```
Create a whsnbg user:
```sh
mysql> CREATE USER 'whsnbg'@'%' IDENTIFIED BY 'some_pass';
```
For more security, you can replace `%` with an IP address of the gateway where [whsnbg](https://github.com/homewsn/whsnbg) program runs.
Then provide the whsnbg user with the permissions:
```sh
mysql> GRANT INSERT,SELECT,UPDATE ON homewsn.* TO ‘whsnbg’@'%’;
```
To enable the Event Scheduler permanently, write `event_scheduler=1` somewhere under the [mysqld] section in the default mysql config file, usually /etc/my.cnf or my.ini. Then restart the MySQL server.

Please be sure all events in the homewsn database are enabled. If not, enable them:
```sh
mysql> ALTER EVENT calc_data_float_day_for_yesterday ENABLE;
mysql> ALTER EVENT calc_data_float_hour_for_yesterday ENABLE;
mysql> ALTER EVENT calc_data_float_month_for_last_month ENABLE;
mysql> ALTER EVENT calc_data_long_day_for_yesterday ENABLE;
mysql> ALTER EVENT calc_data_long_hour_for_yesterday ENABLE;
mysql> ALTER EVENT calc_data_long_month_for_last_month ENABLE;
```
Finally edit MySQL section in the whsnbg.conf file, for example:
```sh
# MySQL section (remote MySQL database)
mysql_enable = 1
mysql_server = 192.168.0.213
mysql_user = whsnbg
mysql_password = some_pass
mysql_database = homewsn
mysql_port = 3306
```
