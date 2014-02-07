exports.config = {
    specs: [
        './integration/shared/**/*.js',
        './integration/**/*-spec.js'
    ],

    jasmineNodeOpts: {
        // Default time to wait in ms before a test fails.
        defaultTimeoutInterval: 50000
    },

    baseUrl: 'http://0.0.0.0:3000'
}