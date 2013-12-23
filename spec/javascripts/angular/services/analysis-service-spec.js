describe("services.AnalysisService", function () {
    var factory;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            factory = $injector.get('services.AnalysisService');
        });
    });

    describe('readings', function () {
        it('Should throw an error when it is not passed a siteId', function () {
            expect(function () {
                factory.readings(11, null, 29, 89);
            }).toThrow();
        });
    });
});