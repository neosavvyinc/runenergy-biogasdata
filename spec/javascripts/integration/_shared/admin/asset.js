var login = require("./login");
var Page = require("astrolabe").Page;

module.exports = Page.create({
    url: {value: '/admin/assets'},
    create: {
        value: function () {
            login.loginAsTrevor();
            return browser.get('/admin/assets/new');;
        }
    }
});