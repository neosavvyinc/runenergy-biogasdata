// Karma configuration
// Generated on Thu Nov 21 2013 08:22:31 GMT-0500 (EST)

module.exports = function (config) {
    config.set({

        // base path, that will be used to resolve files and exclude
        basePath: '',


        // frameworks to use
        frameworks: ['jasmine'],


        // list of files / patterns to load in the browser
        files: [
            '../../vendor/assets/javascripts/bower_components/jquery/jquery.js',
            '../../vendor/assets/javascripts/bower_components/lodash/dist/lodash.js',
            '../../vendor/assets/javascripts/bower_components/momentjs/moment.js',
            '../../vendor/assets/javascripts/bower_components/angular/angular.js',
            '../../vendor/assets/javascripts/bower_components/angular-route/angular-route.js',
            '../../vendor/assets/javascripts/bower_components/d3/d3.js',
            '../../vendor/assets/javascripts/bower_components/nvd3/nv.d3.js',
            '../../vendor/assets/javascripts/bower_components/angularjs-nvd3-directives/dist/angularjs-nvd3-directives.js',
            '../../spec/javascripts/lib/angular-mocks.js',
            '../../spec/javascripts/lib/angular-resource.js',
            '../../spec/javascripts/lib/test-helpers.js',
            '../../vendor/assets/javascripts/bower_components/angular-cache/src/angular-cache.js',
            '../../vendor/assets/javascripts/bower_components/angular-strap/dist/angular-strap.js',
            '../../vendor/assets/javascripts/bower_components/ngQuickDate/dist/ng-quick-date.js',
            '../../vendor/assets/javascripts/bower_components/neosavvy-javascript-core/neosavvy-javascript-core.js',
            '../../vendor/assets/javascripts/bower_components/neosavvy-javascript-angular-core/neosavvy-javascript-angular-core.js',
            '../../vendor/assets/javascripts/bower_components/angular-macgyver/lib/macgyver.js',
            'app/**/*.js',
            'spec/**/*.js'
        ],


        preprocessors: {
            '../../app/assets/javascripts/angular/**/*.js':'coverage'
        },

        // test results reporter to use
        // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
        reporters: ['progress', 'coverage'],

        coverageReporter: {
            type: 'html',
            dir: '../../public/coverage/angular/'
        },

        // web server port
        port: 9876,


        // enable / disable colors in the output (reporters and logs)
        colors: true,


        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: true,


        // Start these browsers, currently available:
        // - Chrome
        // - ChromeCanary
        // - Firefox
        // - Opera (has to be installed with `npm install karma-opera-launcher`)
        // - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
        // - PhantomJS
        // - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
        browsers: ['PhantomJS'],


        // If browser does not capture in given timeout [ms], kill it
        captureTimeout: 60000,


        // Continuous Integration mode
        // if true, it capture browsers, run tests and exit
        singleRun: false
    });
};