var login = require('../../shared/login');
var create = require('../../shared/data_input/create');
var dashboardActions = require('../../shared/shared/dashboard-actions');

describe('/data_input/create', function () {

    beforeEach(function () {
        login.login('tewen@neosavvy.com', 'runenergy007');
        dashboardActions.selectFromDropdown(dashboardActions.operatorDropdown, "Byron Shire Council");
        dashboardActions.selectFromDropdown(dashboardActions.siteDropdown, "Myocum Landfill");
    });

    it('Should return true', function () {
        expect(true).toBeTruthy();
    });
});