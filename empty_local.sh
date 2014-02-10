#!/bin/bash

# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)

TABLES=$($MYSQL -u root runenergy_biogasdata_development -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )

for t in $TABLES
do
	echo "Deleting $t table from $MDB database..."
	$MYSQL -u root runenergy_biogasdata_development -e "drop table $t"
done