var create = require('../../../_shared/data_input/create');
var uuid = require('node-uuid');

describe('user attempts to perform some kind of invalid create operation', function () {

    it('Should get an error for no asset id', function () {
        create.addButton.click();
        expect(create.errorLabel.getText()).toEqual("Please type in or auto select an asset identifier");
    });

    it('Should be able to input an asset uid', function () {
        create.assetUidInput.sendKeys(uuid.v1());
    });

    it('Should set a different error for the lack of date in the assignment', function () {
        create.addButton.click();
        expect(create.errorLabel.getText()).toEqual("Reading date is required");
    });

});