var Location = require('../_shared/admin/location');

describe('create the locations needed for scenarios', function () {

    var location = new Location();

    it('Should create the use', function () {
        location.create("Hammersmith Odeum", "Lemmy Kilmister");
    });

});