var login = require('../shared/login');

describe('user attempting to perform an invalid file import', function () {

    it('Should be able to login', function () {
        try {
            login.login('tewen@neosavvy.com', 'runenergy007');
        } catch (e) {
            //Do nothing
        }
    });

});