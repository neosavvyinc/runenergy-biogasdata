#!/bin/bash

bundle install --deployment --without development test
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake assets:precompile