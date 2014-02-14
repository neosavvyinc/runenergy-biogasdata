var uuid = require('node-uuid');
var Login = require('./login');
var util = require('./util');

module.exports = function () {
    var driver = protractor.getInstance().driver;

    this.create = function (name, usersName) {
        driver.get('http://0.0.0.0:3000/admin/sites/new');

        driver.findElement(by.id("site_site_name")).sendKeys(name || uuid.v1());

        //Select User By Name
        util.optionFromOpenList(by.css('select#site_user_ids'), usersName);

        driver.findElement(by.name('commit')).click();
    };

    this.deleteLocation = function (name) {
        driver.get('http://0.0.0.0:3000/admin/sites');
        driver.findElements(by.tagName('tr')).then(function (trs) {
            //Should be first user on the list
            return trs[1].findElement(by.className('site_name')).getText().then(function (text) {
                if (text === name) {
                    return trs[1].findElement(by.linkText('Delete')).click();
                }
                return null;
            });
        });
        driver.switchTo().alert().accept();
    };
};