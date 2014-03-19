#!/bin/bash

cd /opt/runenergy-biogasdata
bundle exec rake hourly:reading:remedy_missing_keys RAILS_ENV=production
bundle exec rake hourly:reading:mark_collisions RAILS_ENV=production
