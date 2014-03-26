#!/bin/bash

cd /opt/runenergy-biogasdata
bundle exec rake daily:ftp_detail:import RAILS_ENV=production