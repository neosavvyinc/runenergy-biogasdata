var User = require('../_shared/admin/user');

describe('delete the customers needed for scenarios', function () {

    var user = new User();

    it('Should delete the user', function () {
        user.deleteUser("lemmykilmister@gmail.com");
    });

});