var login = require('../../shared/login');
var create = require('../../shared/data_input/create');

describe('/data_input/create', function () {

    beforeEach(function () {
        login.login('tewen@neosavvy.com', 'runenergy007');
    });

    it('Should return true', function () {
        expect(true).toBeTruthy();
    });
});