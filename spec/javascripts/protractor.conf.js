exports.config = {
    specs: [
        './integration/_shared/**/*.js',
        './integration/a-setup/**/*.js',
        './integration/c-teardown/**/*.js'
        //'./integration/**/*-spec.js'
    ],

    jasmineNodeOpts: {
        // Default time to wait in ms before a test fails.
        defaultTimeoutInterval: 50000
    },

    baseUrl: 'http://0.0.0.0:3000'
}