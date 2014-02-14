module.exports = function () {
    var driver = protractor.getInstance().driver;

    this.go = function () {
        return driver.get('http://0.0.0.0:3000/admin');
    };

    this.emailInput = function () {
        return driver.findElement(by.id("admin_user_email"));
    };

    this.passwordInput = function () {
        return driver.findElement(by.id("admin_user_password"));
    };

    this.submitButton = function () {
        return driver.findElement(by.name("commit"));
    };

    this.login = function (username, password) {
        this.go();
        this.emailInput().sendKeys(username);
        this.passwordInput().sendKeys(password);
        return this.submitButton().click();
    };
};