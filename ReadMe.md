### Setting Up the MySQL Database

This repository is a part of the [HomeWSN](http://homewsn.github.io) project.

The MySQL database is required to collect and store the data from the sensors and actuators. 
[Web user interface (WebUI)](https://github.com/homewsn/homewsn.webui) also uses the database to obtain the properties of the devices, and their collected data. 
These data are typically long values, but may be floats and strings. 
The devices initially send their properties and data to [whsnbg](https://github.com/homewsn/whsnbg), which in turn stores them in the database. 

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
Create a whsnbg user for [whsnbg](https://github.com/homewsn/whsnbg):
```sh
mysql> CREATE USER 'whsnbg'@'%' IDENTIFIED BY 'some_pass';
```
For more security, you can replace `%` with an IP address of the gateway where whsnbg runs.
Then provide the whsnbg user with the permissions:
```sh
mysql> GRANT INSERT,SELECT,UPDATE ON homewsn.* TO 'whsnbg'@'%';
```

Create a webui user for [WebUI](https://github.com/homewsn/homewsn.webui):
```sh
mysql> CREATE USER 'webui'@'%' IDENTIFIED BY 'some_pass';
```
For more security, you can replace `%` with an IP address of the web server where php scripts will be run.
Then provide the webui user with the permissions:
```sh
mysql> GRANT SELECT,UPDATE ON homewsn.* TO 'webui'@'%';
```

MySQL events are needed to run procedures to calculate average sensors data values for a hour, day and month. 
This average data will be used in the statistical graphic charts of the WebUI. 
The event will not run unless the Event Scheduler is enabled. 
To enable the Event Scheduler permanently, write `event_scheduler=1` somewhere under the [mysqld] section in the default mysql config file, usually /etc/my.cnf or my.ini. 
Then restart the MySQL server.

Please be sure all events in the homewsn database are enabled. If not, enable them:
```sh
mysql> ALTER EVENT calc_data_for_yesterday ENABLE;
mysql> ALTER EVENT calc_data_for_last_month ENABLE;
```

Edit MySQL section in the [whsnbg.conf](https://github.com/homewsn/whsnbg/blob/master/res/whsnbg.conf) file, for example:
```sh
# MySQL section (remote MySQL database)
mysql_enable = 1
mysql_server = 192.168.0.213
mysql_user = whsnbg
mysql_password = some_pass
mysql_database = homewsn
mysql_port = 3306
```

Finally edit [mysql.inc](https://github.com/homewsn/homewsn.webui/blob/master/mysql.inc) file, for example:
```php
<?php
$host = "192.168.0.213";
$user = "webui";
$pass = "some_pass";
$db = "homewsn";
?>
```
