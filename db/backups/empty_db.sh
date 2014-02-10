#!/bin/bash
MUSER="$1"
MDB="$2"
MPASSWORD="$3"
MHOST="$4"

# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)

if [ $# -ne 4 ]
then
	echo "Usage: $0 {MySQL-User-Name} {MySQL-Database-Name} {MySQL-Database-Password} {MySQL-Host}"
	echo "Drops all tables from a MySQL"
	exit 1
fi

TABLES=$($MYSQL -h $MHOST -u $MUSER -p$MPASSWORD $MDB -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )

for t in $TABLES
do
	echo "Deleting $t table from $MDB database..."
	$MYSQL -h $MHOST -u $MUSER -p$MPASSWORD $MDB -e "drop table $t"
done