var util = require('./util');

module.exports = function () {
    var driver = protractor.getInstance().driver;

    this.create = function (name, locationName) {
        driver.get('http://0.0.0.0:3000/admin/monitor_classes/new');
        driver.findElement(by.id('monitor_class_name')).sendKeys(name);
        util.optionFromOpenList(by.css('select#monitor_class_location_ids'), locationName);
        driver.findElement(by.name('commit')).click();
    };
    
    this.edit = function () {
        
    }

    this.deleteMonitorClass = function (name) {
        driver.get('http://0.0.0.0:3000/admin/monitor_classes');
        driver.findElements(by.tagName('tr')).then(function (trs) {
            //Should be first monitor class on the list
            return trs[1].findElement(by.className('name')).getText().then(function (text) {
                if (text === name) {
                    return trs[1].findElement(by.linkText('Delete')).click();
                }
                return null;
            })
        });
        driver.switchTo().alert().accept();
    };

};