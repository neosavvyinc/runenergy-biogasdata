var Page = require("astrolabe").Page;

module.exports = Page.create({
    url: {value: '/data_input/import'},
    container: {
        get: function () {
            return element(by.className('import'));
        }
    },
    importFileButton: {
        get: function () {
            return element(by.name('commit'));
        }
    },
    errorLabel: {
        get: function () {
            return element(by.binding('error'));
        }
    }
});