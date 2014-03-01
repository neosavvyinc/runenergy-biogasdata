describe("services.DataInputService", function () {
    var service, routes, requestSpy;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            service = $injector.get('services.DataInputService');
            routes = $injector.get('constants.Routes');
            requestSpy = spyOnAngularService($injector.get('nsServiceExtensions'), 'request', [1, 2, 3]);
        });
    });

    describe('createReading', function () {
        it('Should call the requestSpy with the given properties in a post request', function () {
            var myDate = new Date();
            service.createReading(9, 7, "AWW567", 5, 4, myDate);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'POST',
                url: routes.DATA_INPUT.CREATE,
                data: {
                    site_id: 9,
                    monitor_class_id: 7,
                    asset_unique_identifier: "AWW567",
                    field_log: 5,
                    reading: 4,
                    date_time: parseInt(myDate.getTime() / 1000)
                }
            });
        });

        it('Should return the value from nsServiceExtensions', function () {
            var myResult;
            service.createReading(9, 7, 5, 4, 3, new Date()).then(function (result) {
                myResult = result
            });
            expect(myResult).toEqual([1, 2, 3]);
        });
    });

    describe('createMonitorPoint', function () {
        it('Should call the requestSpy with the parameters', function () {
            service.createMonitorPoint(15, 17, "Methane", "%");
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'POST',
                url: routes.DATA_INPUT.CREATE_MONITOR_POINT,
                data: {site_id: 15, monitor_class_id: 17, name: "Methane", unit: "%"}
            });
        });
    });

    describe('readings', function () {
        it('Should call nsServiceExtensions with the required parameters', function () {
            service.readings(1005, 890);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'GET',
                url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.READINGS).
                    paramReplace({':site_id': 1005, ':monitor_class_id': 890}).
                    build()
            });
        });

        it('Should return the value from nsServiceExtensions', function () {
            var myResult;
            service.readings(1, 5).then(function (result) {
                myResult = result
            });
            expect(myResult).toEqual([1, 2, 3]);
        });
    });
});