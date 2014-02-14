var Asset = require('../_shared/admin/asset');

describe('delete the assets needed for scenarios', function () {

    var asset = new Asset();

    it('Should delete the assets', function () {
        asset.deleteAsset("G String");
        asset.deleteAsset("D String");
        asset.deleteAsset("A String");
        asset.deleteAsset("E String");
    });

});