module.exports = function () {
    var driver = protractor.getInstance().driver;

    this.createCustomer = function (name, username, password) {
        driver.get('http://0.0.0.0:3000/admin/customers_viewers/new');
        driver.findElement(by.css('select#customers_viewers_user_type_id option:nth-child(3)')).click();
        driver.findElement(by.id('customers_viewers_name')).sendKeys(name);
        driver.findElement(by.id('customers_viewers_email')).sendKeys(username);
        driver.findElement(by.id('customers_viewers_password')).sendKeys(password);
        driver.findElement(by.id('customers_viewers_password_confirmation')).sendKeys(password);
        driver.findElement(by.id('customers_viewers_edit_permission')).click();
        driver.findElement(by.name('commit')).click();
    };

    this.deleteUser = function (username) {
        driver.get('http://0.0.0.0:3000/admin/customers_viewers');
        driver.findElements(by.tagName('tr')).then(function (trs) {
            //Should be first user on the list
            return trs[1].findElement(by.className('email')).getText().then(function (text) {
                if (text === username) {
                    return trs[1].findElement(by.linkText('Delete')).click();
                }
                return null;
            })
        });
        driver.switchTo().alert().accept();
    };
};