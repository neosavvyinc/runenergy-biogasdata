// base path, that will be used to resolve files and exclude
basePath = '../../app/assets/javascripts/angular/';

// list of files / patterns to load in the browser
files = [

    JASMINE,
    JASMINE_ADAPTER,

    //libraries
    '../../../../spec/javascripts/lib/angular.js',
    '../../../../spec/javascripts/lib/angular-resource.js',
    '../../../../spec/javascripts/lib/angular-mocks.js',

    //requirements
    'dashboard.js',
    'core/**/*.js',

    //tests
    '../../../../spec/javascripts/angular/**/*-spec.js'
];

// generate js files from html templates
preprocessors = {
    '**/*.html': 'html2js'
};

// list of files to exclude
exclude = [];

// use dots reporter, as travis terminal does not support escaping sequences
// possible values: 'dots' || 'progress'
reporter = 'progress';

// web server port
port = 8080;

// cli runner port
runnerPort = 9100;

// enable / disable colors in the output (reporters and logs)
colors = true;

// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;

// enable / disable watching file and executing tests whenever any file changes
autoWatch = true;

// polling interval in ms (ignored on OS that support inotify)
autoWatchInterval = 100;

// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari
browsers = ['Chrome'];
//browsers = ['Chrome', 'Firefox', 'Safari'];

// Auto run tests on start (when browsers are captured) and exit
singleRun = false;
