#!/bin/sh
$BACKUP_DATE = "$1"

if [ $# -ne 1 ]
then
  echo "Usage: $0 {Backup Date}"
  echo "Imports production from the backup date specified in YYYYMMDD"
  exit 1
fi

mysql -h 432aff3dded8d43d3be2e8e4cfb449c15c4fcd7e.rackspaceclouddb.com -u biogasdata -pgijoeskillz runenergy_biogasdata_production_20 < runenergy_biogasdata_development_$1.sql