#!/bin/bash

bundle install --deployment --without development test
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake db_inserts:all RAILS_ENV=production
bundle exec rake assets:precompile
service apache2 restart