#!/bin/sh

bundle exec rake db:migrate
bundle exec rake db:test:prepare
bundle exec rspec
cd spec/javascripts
npm install
karma start karma-ci.conf.js

