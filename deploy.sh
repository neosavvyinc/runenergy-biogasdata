#!/bin/bash

bundle install --deployment --without development test
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake db_inserts:all RAILS_ENV=production

#Remove bad bower libraries, just a temp fix
rm -r vendor/assets/bower_components/angular
rm -r vendor/assets/javascripts/bower_components/angular

bundle exec rake assets:precompile
service apache2 restart