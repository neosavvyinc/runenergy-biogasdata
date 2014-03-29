#!/bin/sh

bundle exec rake helpers:asset:import_heat_map_coordinates['/opt/runenergy-biogasdata/surfer/support/xy_data_for_sites_20140328.csv'] RAILS_ENV=production