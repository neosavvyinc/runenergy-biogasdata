var Page = require("astrolabe").Page;

module.exports = Page.create({
    url: {value: '/admin'},
    email: {
        get: function () {
            return element(by.id("admin_user_email"));
        }
    },
    password: {
        get: function () {
            return element(by.id("admin_user_password"));
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
    },
    loginAsTrevor: {
        value: function () {
            return this.login("tewen@neosavvy.com", "runenergy007");
        }
    }
});