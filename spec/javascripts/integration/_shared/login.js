var Page = require("astrolabe").Page;

module.exports = Page.create({
    url: {value: '/'},
    email: {
        get: function () {
            return element(by.id("user_email"));
        }
    },
    password: {
        get: function () {
            return element(by.id("user_password"));
        }
    },
    submit: {
        get: function () {
            return element(by.name("commit"));
        }
    },
    login: {
        value: function (username, password) {
            this.go();
            this.email.sendKeys(username);
            this.password.sendKeys(password);
            return this.submit.click();
        }
    }
});