#!/bin/sh

bundle exec rake db:migrate
bundle exec rake db:test:prepare
bundle exec rspec
karma start spec/javascripts/karma-ci.conf.js

