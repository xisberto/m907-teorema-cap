CREATE USER 'repluser'@'%' IDENTIFIED BY 'replsecret';
GRANT REPLICATION SLAVE ON *.* TO 'repluser'@'%';

CREATE USER 'monitor_user'@'%' IDENTIFIED BY 'monitorsecret';
GRANT REPLICATION CLIENT on *.* to 'monitor_user'@'%';
GRANT SUPER, RELOAD on *.* to 'monitor_user'@'%';

CREATE USER 'maxscale'@'%' IDENTIFIED BY 'maxscale_pw';
GRANT SELECT ON mysql.user TO 'maxscale'@'%';
GRANT SELECT ON mysql.db TO 'maxscale'@'%';
GRANT SELECT ON mysql.tables_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.columns_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.procs_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.proxies_priv TO 'maxscale'@'%';
GRANT SELECT ON mysql.roles_mapping TO 'maxscale'@'%';
GRANT SHOW DATABASES ON *.* TO 'maxscale'@'%';

CREATE DATABASE appname;

CREATE USER 'appuser'@'%' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON appname.* to 'appuser'@'%';