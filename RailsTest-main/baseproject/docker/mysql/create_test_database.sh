#!/bin/sh

# https://unix.stackexchange.com/questions/435482/how-to-deal-with-multiline-strings-and-string-interpolation

mysql -u root -p$MYSQL_ROOT_PASSWORD <<- EOM
  CREATE DATABASE IF NOT EXISTS ${MYSQL_TEST_DATABASE};
  GRANT ALL ON ${MYSQL_TEST_DATABASE}.* TO '${MYSQL_USER}'@'%';
EOM