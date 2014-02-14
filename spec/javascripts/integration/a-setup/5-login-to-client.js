var login = require('../_shared/login');

describe('user attempting to perform an invalid file import', function () {

    it('Should be able to login', function () {
        login.login('lemmykilmister@gmail.com', 'runenergy007');
    });

});