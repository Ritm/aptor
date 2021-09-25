#! /bin/sh
set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable
service mariadb restart
#Generate 10 symbols password
pass=$(head /dev/urandom | tr -dc A-Za-z0-9*-[]{}^ | head -c20)
userpass=$(head /dev/urandom | tr -dc A-Za-z0-9*-[]{}^ | head -c20)
echo $pass > /sqlsafe.txt
echo $userpass >> /sqlsafe.txt
echo "define( 'DB_PASSWORD', '${userpass}' );" >>/tmp/wp-config-docker.php
is_mysql_root_password_set() {
  ! mysqladmin --user=root status > /dev/null 2>&1
}
is_mysql_command_available() {
  which mysql > /dev/null 2>&1
}
#db_root_password=$pass
if ! is_mysql_command_available; then
  echo "The MySQL client mysql(1) is not installed."
  exit 1
fi

if is_mysql_root_password_set; then
  echo "Database root password already set"
  exit 0
fi

mysql -uroot <<_EOF_
  UNINSTALL SONAME 'cracklib_password_check';
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${pass}';
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  CREATE DATABASE wordpress;
  CREATE USER 'username'@'localhost' IDENTIFIED BY '${userpass}';
  GRANT ALL PRIVILEGES ON wordpress . * TO 'username'@'localhost';
  FLUSH PRIVILEGES;
_EOF_
