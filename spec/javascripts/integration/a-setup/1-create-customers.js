var User = require('../_shared/admin/user');

describe('create the customers needed for scenarios', function () {

    var user = new User();

    it('Should create the use', function () {

        user.createCustomer("Lemmy Kilmister", "lemmykilmister@gmail.com", "runenergy007");

    });

});