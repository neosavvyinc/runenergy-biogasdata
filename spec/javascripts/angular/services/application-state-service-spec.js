describe("services.ApplicationStateService", function () {
    var factory;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            factory = $injector.get('services.ApplicationStateService');
        });
    });
});