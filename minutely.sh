#!/bin/bash

/bin/bash -l -c 'cd /opt/runenergy-biogasdata && RAILS_ENV=production script/delayed_job restart >> /opt/runenergy-biogasdata/log/cron_log.log 2>&1'