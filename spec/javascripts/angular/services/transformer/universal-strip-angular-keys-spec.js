describe("service.transformer.UniversalStripAngularKeysRequest", function () {
    var transformer, request;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            transformer = $injector.get('service.transformer.UniversalStripAngularKeysRequest');
        });

        request = {id: 54, $$hashKey: "CMU"};
    });

    it('Should return undefined when passed', function () {
        expect(transformer(undefined)).toBeUndefined();
    });

    it('Should return null when passed', function () {
        expect(transformer(null)).toBeNull();
    });

    it('Should send up a blank stringified object when passed one', function () {
        expect(transformer({})).toEqual(JSON.stringify({}));
    });

    it('Should strip out the $$hashKey from an angularized json object', function () {
        expect(transformer(request)).toEqual(JSON.stringify({id: 54}));
    });

});