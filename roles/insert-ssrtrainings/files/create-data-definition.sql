CREATE DATABASE IF NOT EXISTS ssrtraining CHARACTER SET utf8mb4;
USE ssrtraining;
DROP TABLE data;
CREATE TABLE IF NOT EXISTS data ( date timestamp, person varchar(50), `set` int, liegestueze int, situps int, schwimm int, grizzli int, ccl int, ccr int, ff int, ouino int, kabr int, kniebeuge int, PRIMARY KEY(date,person,`set`)) ENGINE=INNODB;
CREATE USER IF NOT EXISTS 'ssrtraining'@'%' IDENTIFIED BY '{{ mysql.ssrtraining_password }}';
GRANT select ON ssrtraining.* TO 'ssrtraining'@'%';
FLUSH PRIVILEGES;