CREATE USER 'repluser'@'%' IDENTIFIED BY 'replsecret';
GRANT REPLICATION SLAVE ON *.* TO 'repluser'@'%';

CREATE USER 'monitor_user'@'%' IDENTIFIED BY 'monitorsecret';
GRANT REPLICATION CLIENT on *.* to 'monitor_user'@'%';
GRANT REPLICA MONITOR on *.* to 'monitor_user'@'%';
GRANT CONNECTION ADMIN on *.* to 'monitor_user'@'%';
GRANT SLAVE MONITOR on *.* to 'monitor_user'@'%';
GRANT READ_ONLY ADMIN on *.* to 'monitor_user'@'%';
GRANT BINLOG ADMIN on *.* to 'monitor_user'@'%';
GRANT REPLICATION SLAVE ADMIN on *.* to 'monitor_user'@'%';
GRANT REPLICATION SLAVE on *.* to 'monitor_user'@'%';

CREATE USER 'maxscale'@'%' IDENTIFIED BY 'maxscalesecret';
GRANT SELECT ON mysql.user TO 'maxscale'@'%';
GRANT SELECT ON mysql.db TO 'maxscale'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.columns_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.procs_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.proxies_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.roles_mapping TO 'maxscale'@'%';
GRANT SHOW DATABASES ON *.* TO 'maxscale'@'%';

CREATE DATABASE appname;
CREATE TABLE appname.usertable (
	YCSB_KEY VARCHAR(255) PRIMARY KEY,
	FIELD0 TEXT, FIELD1 TEXT,
	FIELD2 TEXT, FIELD3 TEXT,
	FIELD4 TEXT, FIELD5 TEXT,
	FIELD6 TEXT, FIELD7 TEXT,
	FIELD8 TEXT, FIELD9 TEXT
);

CREATE USER 'appuser'@'%' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON appname.* to 'appuser'@'%';