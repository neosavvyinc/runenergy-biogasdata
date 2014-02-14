var Page = require("astrolabe").Page;

module.exports = Page.create({
    container: {
        get: function () {
            return element(by.className('dashboard-actions'));
        }
    },
    operatorDropdown: {
        get: function () {
            return this.container.element(by.className('operator'));
        }
    },
    siteDropdown: {
        get: function () {
            return this.container.element(by.className('location'));
        }
    },
    monitorClassDropdown: {
        get: function () {
            return this.container.element(by.className('monitor-class'));
        }
    },
    sectionDropdown: {
        get: function () {
            return this.container.element(by.className('section'));
        }
    },
    assetDropdown: {
        get: function () {
            return this.container.element(by.className('asset'));
        }
    },
    selectFromDropdown: {
        value: function (dropdown, name) {
            return dropdown.click().then(dropdown.element(by.linkText(name)).click);
        }
    },
    filters: {
        value: function (operator, site, monitorClass) {
            this.selectFromDropdown(this.operatorDropdown, operator);
            this.selectFromDropdown(this.siteDropdown, site);
            return this.selectFromDropdown(this.monitorClassDropdown, monitorClass);
        }
    }
});