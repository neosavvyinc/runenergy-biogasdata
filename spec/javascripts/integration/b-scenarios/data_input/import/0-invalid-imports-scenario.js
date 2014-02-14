var login = require('../../../_shared/login');
var importView = require('../../../_shared/data_input/import');
var dashboardActions = require('../../../_shared/shared/dashboard-actions');

describe('user attempting to perform an invalid file import', function () {

    it('Should be able to the import page', function () {
        importView.go();
        expect(browser.getCurrentUrl()).toContain('/data_input/import');
    });

    describe('no site selected', function () {

        it('Should show a message on import', function () {
            importView.importFileButton.click();
            expect(importView.errorLabel.getText()).toEqual('You must select a site before uploading');
        });

        describe('no monitor class selected', function () {
            it('Should be able to select a site', function () {
                dashboardActions.selectFromDropdown(dashboardActions.siteDropdown, 'Hammersmith Odeum');
            });

            it('Should get an error message about a missing monitor class', function () {
                importView.importFileButton.click();
                expect(importView.errorLabel.getText()).toEqual('You must select a monitor class before uploading');
            });
        });

    });
});