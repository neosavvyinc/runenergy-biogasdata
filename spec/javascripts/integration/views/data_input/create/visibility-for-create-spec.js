var assetAdmin = require('../../../shared/admin/asset')
var login = require('../../../shared/login');
var create = require('../../../shared/data_input/create');
var dashboardActions = require('../../../shared/shared/dashboard-actions');

describe('/data_input/create', function () {

    it('Should be able to go to the create page', function () {
        create.go();
        expect(browser.getCurrentUrl()).toContain('/data_input/create');
    });

    describe('no filters', function () {

        it('Should not show the create form', function () {
            expect(create.createForm.isDisplayed()).toBeFalsy();
        });

        it('Should not show or have the assign form', function () {
            expect(create.assignForm.isPresent()).toBeFalsy();
        });

        it('Should not show the data analysis table', function () {
            expect(create.analysisTable.isDisplayed()).toBeFalsy();
        });

        describe('filters', function () {
            it('Should be able to set filters', function () {
                dashboardActions.filters("Byron Shire Council", "Myocum Landfill", "Landfill Pump");
            });

            describe('create form', function () {
                it('Should display the asset unique identifier input', function () {

                });

                it('Should display the create form', function () {
                    expect(create.createForm.isDisplayed()).toBeTruthy();
                });
            });

            describe('data analysis table', function () {
                it('Should display the data analysis table', function () {
                    expect(create.analysisTable.isDisplayed()).toBeTruthy();
                });
            });

        });
    });

});