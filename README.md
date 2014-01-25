runenergy-biogasdata
====================

The Run Energy Flare Data, Leachate, and Gas dashboard.

# Setting up the Rails Environment

## Ruby on Rails
Make sure you have Ruby and Ruby on Rails installed. This project is using Ruby 2.0.0p0 and Rails '3.2.12'

Check out the following for Mac installation instructions: http://railsinstaller.org/en

My Rails environment has been installed for a long time, but that resource looks promising.

From the root of the project, run the following command:

```Shell
bundle install
```

## MySQL
You will need to have MySQL installed on your machine. I am running: Ver 14.14 Distrib 5.6.13

MySQL dumps are stored in the db/backups folder. Pull the latest development dump into your database. Your configuration will
be simpler if your database has root as the username and no password:

```Shell
mysql -u root runenergy_biogasdata_development << runenergy_biogasdata_development_YYYYMMDD.sql
```

## Tests
You can run the tests for Rails in the root directory using the runtests.sh shell script:

```Shell
./runtests.sh
```

## Server
You can run the rails server and see the app in motion by typing:

```Shell
rails server
```

Navigate your browser to 0.0.0.0:3000

Username: mayday@neosavvy.com
Password: mayday123



# Angular Unit Tests

```Shell
cd spec/javascripts
karma start karma.conf.js
```

Application files for the Angular application are located in assets/javascripts/angular/

Spec files for the Angular application are located in spec/javascripts/angular/

A coverage report will be generated at public/coverage/angular/{CHROME VERSION}/index.html

Open the report to see what still needs to be tested, should have a clickable file tree

