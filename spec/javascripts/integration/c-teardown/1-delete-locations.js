var Location = require('../_shared/admin/location');

describe('delete the locations needed for scenarios', function () {

    var location = new Location();

    it('Should create the use', function () {
        location.deleteLocation("Hammersmith Odeum");
    });

});