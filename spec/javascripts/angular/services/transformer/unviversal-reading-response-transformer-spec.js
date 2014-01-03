describe("service.transformer.UniversalReadingResponseTransformer", function () {
    var transformer, response;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            transformer = $injector.get('service.transformer.UniversalReadingResponseTransformer');
        });

        response = JSON.stringify({});
    });

});