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
            service.createReading(9, 7, "AWW567", 5, 4, 3, 1);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'POST',
                url: routes.DATA_INPUT.CREATE,
                data: {
                    site_id: 9,
                    monitor_class_id: 7,
                    asset_unique_identifier: "AWW567",
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

    describe('completeImportCsv', function () {
        it('Should throw an error if no readings are provided', function () {
            expect(function () {
                service.completeImportCsv(null, {});
            }).toThrow();
        });

        it('Should throw an error if readings is empty', function () {
            expect(function () {
                service.completeImportCsv([], {});
            }).toThrow();
        });

        it('Should throw an error if no column names to monitor points mappings are provided', function () {
            expect(function () {
                service.completeImportCsv([1, 2, 3], null);
            }).toThrow();
        });

        it('Should call the nsServiceExtensions with the required params', function () {
            service.completeImportCsv([1, 2, 3], {name: 'namen'}, [3, 7], {column_a: true});
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'POST',
                url: routes.DATA_INPUT.COMPLETE_IMPORT,
                data: {
                    readings: [1, 2, 3],
                    reading_mods: {
                        deleted_row_indices: [3, 7],
                        deleted_columns: {column_a: true},
                        column_to_monitor_point_mappings: {name: 'namen'}
                    }
                }
            });
        });

        it('Should return the value from nsServiceExtensions', function () {
            var myResult;
            service.completeImportCsv([1, 2, 3], {name: 'namen'}, [3, 7], {column_a: true}).then(function (result) {
                myResult = result
            });
            expect(myResult).toEqual([1, 2, 3]);
        });
    });
});