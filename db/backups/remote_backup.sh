#!/bin/bash

mysqldump -h 432aff3dded8d43d3be2e8e4cfb449c15c4fcd7e.rackspaceclouddb.com -u biogasdata -pgijoeskillz runenergy_biogasdata_production > production_$(date +"%Y%m%d").sql