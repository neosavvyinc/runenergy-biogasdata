describe("services.transformer.DataInputCreateTransformer", function () {
    var transformer, response;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            transformer = $injector.get('services.transformer.DataInputCreateTransformer');
        });

        response = {name: "Charles"};
    });

    it('Should return a parsed json response', function () {
        expect(transformer(response)).toEqual( JSON.stringify(response));
    });
});