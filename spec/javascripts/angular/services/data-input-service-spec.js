describe("services.DataInputService", function () {
    var factory, routes;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            factory = $injector.get('services.DataInputService');
            routes = $injector.get('constants.Routes');
        });
    });

    describe('createReading', function () {

    });

    describe('readings', function () {

    });
});