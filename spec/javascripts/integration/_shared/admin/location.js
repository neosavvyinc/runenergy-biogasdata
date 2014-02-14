var Login = require('./login');
var uuid = require('node-uuid');

module.exports = function () {
    var driver = protractor.getInstance().driver;

    this.create = function (name, usersName) {
        driver.get('http://0.0.0.0:3000/admin/sites/new');

        driver.findElement(by.id("site_site_name")).sendKeys(name || uuid.v1());

        //Select User By Name
        driver.findElement(by.css('select#site_user_ids option:contains("' + usersName + '")')).click();

        driver.findElement(by.name('commit'));
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
            })
        });
    };
};