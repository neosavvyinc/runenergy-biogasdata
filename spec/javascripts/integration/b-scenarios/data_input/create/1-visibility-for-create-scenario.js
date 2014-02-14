var login = require('../../../_shared/login');
var create = require('../../../_shared/data_input/create');

describe('create form visibility', function () {

    it('Should not show the data analysis table', function () {
        expect(create.analysisTable.isDisplayed()).toBeFalsy();
    });

    it('Should display the create form', function () {
        expect(create.createForm.isDisplayed()).toBeTruthy();
    });

});