module.exports = (function () {
    var driver = protractor.getInstance().driver;

    return {
        optionFromOpenList: function (selector, name) {
            var desiredOption = null;
            return driver
                .findElement(selector)
                .findElements(by.tagName('option'))
                .then(function findMatchingOption(options) {
                    options.some(function (option) {
                        option.getText().then(function doesOptionMatch(text) {
                            if (name === text) {
                                desiredOption = option
                                return true;
                            }
                        });
                    });
                }).then(function () {
                    return desiredOption.click();
                });
        }
    }
})();