var Asset = require('../_shared/admin/asset');

describe('delete the assets needed for scenarios', function () {

    var asset = new Asset();

    it('Should delete the assets', function () {
        asset.create("E String", "Hammersmith Odeum", "Amplifier Volume");
        asset.create("A String", "Hammersmith Odeum", "Amplifier Volume");
        asset.create("D String", "Hammersmith Odeum", "Amplifier Volume");
        asset.create("G String", "Hammersmith Odeum", "Amplifier Volume");
    });

});