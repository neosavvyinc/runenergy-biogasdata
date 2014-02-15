#!/bin/bash

cd /opt/runenergy-biogasdata
bundle exec rake hourly:reading:remedy_missing_keys RAILS_ENV=production
