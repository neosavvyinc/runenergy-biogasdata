var login = require('../../../shared/login');
var create = require('../../../shared/data_input/create')
var dashboardActions = require('../../../shared/shared/dashboard-actions');
var uuid = require('node-uuid')

describe('user attempts to perform some kind of invalid create operation', function () {

    it('Should go to the create page', function () {
        create.go();
        expect(browser.getCurrentUrl()).toContain('/data_input/create')
    });

    it('Should be able to select the required filters for display', function () {
        dashboardActions.filters("Byron Shire Council", "Myocum Landfill", "Landfill Pump");
    });

    describe('no asset uid', function () {

        it('Should get an error for no asset id', function () {
            create.addButton.click();
            expect(create.errorLabel.getText()).toEqual("Please type in or auto select an asset identifier");
        });

        describe('no date', function () {

            it('Should be able to input an asset uid', function () {
                create.assetUidInput.sendKeys(uuid.v1());
            });

            it('Should set a different error for the lack of date in the assignment', function () {
                create.addButton.click();
                expect(create.errorLabel.getText()).toEqual("Reading date is required");
            });
        });

    });
});