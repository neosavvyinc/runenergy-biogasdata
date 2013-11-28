#!/bin/sh

rake db:test:load
bundle exec guard start
