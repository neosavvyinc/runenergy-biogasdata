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
    assignButtonAt: {
        value: function (idx) {
            return this.container.element.all(by.className('qa-assign-monitor-point-button')).then(function (buttons) {
                return buttons[idx].click();
            });
        }
    },
    assignSubmitButton: {
        get: function () {
            return this.container.element(by.className('qa-assign-button'));
        }
    },
    analysisTable: {
        get: function () {
            return this.container.element(by.className('data-table'));
        }
    },
    addButton: {
        get: function () {
            return this.container.element(by.className('qa-add-create'));
        }
    },
    errorLabel: {
        get: function () {
            return this.container.element(by.className('qa-main-error'));
        }
    },
    assetUidInput: {
        get: function () {
            return this.container.element(by.className('qa-asset-unique-identifier'));
        }
    },
    selectFirstDayOfWeek: {
        value: function () {
            return this.container.element(by.className('quickdate-button')).click().then(function () {
                return element(by.repeater('day in week').row(0)).click
            });
        }
    },
    sendKeysInputAt: {
        value: function (idx, value) {
            return this.container.element.all(by.className('qa-monitor-point-input')).then(function (inputs) {
                return inputs[idx].sendKeys(value);
            });
        }
    }
});