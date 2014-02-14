var create = require('../../../_shared/data_input/create');

xdescribe('creating data in the add data input', function () {

    it('Should be able to enter data', function () {
        create.selectFirstDayOfWeek();
    });

    it('Should be able to enter values into the monitor points', function () {
        create.sendKeysInputAt(0, Math.random() * 1000);
        create.sendKeysInputAt(1, Math.random() * 1000);
        create.sendKeysInputAt(2, Math.random() * 1000);
        create.sendKeysInputAt(3, Math.random() * 1000);
    });

    it('Should be able to add the data and make a service request', function () {
        create.addButton.click();
    });

    it('Should display the data analysis table', function () {
        expect(create.analysisTable.isDisplayed()).toBeTruthy();
    });
});