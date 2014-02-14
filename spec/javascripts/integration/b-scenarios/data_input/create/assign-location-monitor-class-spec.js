/* Admin Views */
var Location = require('../../../_shared/admin/location');

/* Angular Views */
var login = require('../../../_shared/login');
var dashboardActions = require('../../../_shared/shared/dashboard-actions');

ddescribe('user wants to assign a specific monitor class for a location to the location', function () {

    var location = new Location();

    it('Should be able to create a new location for the test', function () {
        location.go();
        location.create();
    });


});
