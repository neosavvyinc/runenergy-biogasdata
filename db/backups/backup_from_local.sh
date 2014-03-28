#!/bin/sh

mysqldump -u root runenergy_biogasdata_development > recent.sql
cp recent.sql runenergy_biogasdata_development_$(date +"%Y%m%d").sql
echo "Backup complete"
