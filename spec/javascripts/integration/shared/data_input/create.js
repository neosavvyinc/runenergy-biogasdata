var Page = require("astrolabe").Page;

module.exports = Page.create({
    url: {value: '/data_input/create'},
    container: {
        get: function () {
            return element(by.className('data-input'));
        }
    },
    createForm: {
        get: function () {
            return this.container.element(by.className('qa-create-tools'));
        }
    },
    assignForm: {
        get: function () {
            return this.container.element(by.className('qa-assign-tools'));
        }
    },
    analysisTable: {
        get: function () {
            return this.container.element(by.className('data-table'));
        }
    }
});