var Login = require('../../shared/admin/login');

describe('user attempting to perform an invalid file import', function () {

    var login = new Login();

    it('Should be able to login', function () {
        login.login('tewen@neosavvy.com', 'runenergy007');
    });

});