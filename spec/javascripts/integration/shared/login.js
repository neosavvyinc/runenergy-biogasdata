var Page = require("astrolabe").Page;

module.exports = Page.create({
    url: {value: '/'},
    login: {
        value: function (username, password) {
            this.go();
            return element(by.id("user_email")).sendKeys(username)
                .then(function () {
                    return element(by.id("user_password")).sendKeys(password);
                })
                .then(element(by.name("commit")).click);
        }
    }
});