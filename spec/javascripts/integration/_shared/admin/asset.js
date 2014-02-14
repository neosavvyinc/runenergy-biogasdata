var util = require('./util');

module.exports = function () {
    var driver = protractor.getInstance().driver;

    this.create = function (uid, locationName, monitorClassName) {
        driver.get('http://0.0.0.0:3000/admin/assets/new');

        driver.findElement(by.id('asset_unique_identifier')).sendKeys(uid);
        driver.findElement(by.id('asset_name')).sendKeys(uid);

        util.optionFromClosedList(by.css('select#asset_location_id'), locationName);
        util.optionFromClosedList(by.css('select#asset_monitor_class_id'), monitorClassName);

        driver.findElement(by.name('commit')).click();
    };

    this.deleteAsset = function (uid) {
        driver.get('http://0.0.0.0:3000/admin/assets');
        driver.findElements(by.tagName('tr')).then(function (trs) {
            //Should be first user on the list
            return trs[1].findElement(by.className('unique_identifier')).getText().then(function (text) {
                if (text === uid) {
                    return trs[1].findElement(by.linkText('Delete')).click();
                }
                return null;
            });
        });
        driver.switchTo().alert().accept();
    };
};