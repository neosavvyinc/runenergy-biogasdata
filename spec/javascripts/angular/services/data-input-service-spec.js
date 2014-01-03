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
            service.createReading(9, 7, 5, 4, 3, 1);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'POST',
                url: routes.DATA_INPUT.CREATE,
                data: {
                    asset_id: 9,
                    monitor_class_id: 7,
                    field_log: 5,
                    reading: 4,
                    date: 3,
                    time: 1
                }
            });
        });

        it('Should return the value from nsServiceExtensions', function () {
            var myResult;
            service.createReading(9, 7, 5, 4, 3, 1).then(function (result) {
                myResult = result
            });
            expect(myResult).toEqual([1, 2, 3]);
        });
    });

    describe('readings', function () {
        it('Should call nsServiceExtensions with the required parameters', function () {
            service.readings(1005, 890);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'GET',
                url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.READINGS).
                    paramReplace({':asset_id': 1005, ':monitor_class_id': 890}).
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

    describe('importCsv', function () {
        it('Should call the nsServiceExtensions with the required params', function () {
            service.importCsv({age: 15});
            expect(requestSpy).toHaveBeenCalledWith({method: 'POST', url: routes.DATA_INPUT.IMPORT, data: {age: 15}});
        });

        it('Should return the value from nsServiceExtensions', function () {
            var myResult;
            service.importCsv(1).then(function (result) {
                myResult = result
            });
            expect(myResult).toEqual([1, 2, 3]);
        });
    });
});