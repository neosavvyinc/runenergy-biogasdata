var create = require('../../../_shared/data_input/create');
var dashboardActions = require('../../../_shared/shared/dashboard-actions');

describe('assign monitor points to a location monitor class', function () {

    it('Should go to the create page', function () {
        create.go();
        expect(browser.getCurrentUrl()).toContain('/data_input/create');
    });

    it('Should be able to select the required filters for display', function () {
        dashboardActions.filters("Lemmy Kilmister", "Hammersmith Odeum", "Amplifier Volume");
    });

    it('Should show the assign form', function () {
        expect(create.assignForm.isDisplayed()).toBeTruthy();
    });

    it('Should select the first 4 elements', function () {
        create.assignButtonAt(0);
        create.assignButtonAt(1);
        create.assignButtonAt(2);
        create.assignButtonAt(3);
    });

    it('Should be able to click the assign submit button', function () {
        create.assignSubmitButton.click();
    });

});
