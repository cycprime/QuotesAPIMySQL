DROP DATABASE IF EXISTS `test_database`;
CREATE DATABASE test_database;
CREATE USER 'test_user'@'%' IDENTIFIED BY 'testuser';
GRANT ALL PRIVILEGES ON test_database.* TO 'test_user'@'%';
FLUSH PRIVILEGES;
