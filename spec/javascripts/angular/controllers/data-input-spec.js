describe("controllers.DataInputController", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller,
        routes,
        dataInputServiceCreateSpy,
        dataInputServiceReadingSpy;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            routes = $injector.get('constants.Routes');
            dataInputServiceCreateSpy = spyOnAngularService($injector.get('services.DataInputService'), 'createReading', {then: function (fn) {
                return fn();
            }});
            dataInputServiceReadingSpy = spyOnAngularService($injector.get('services.DataInputService'), 'readings', null);
            controller = $injector.get('$controller')("controllers.DataInputController", {$scope: $scope});
        });
    });

    describe('Action Handlers', function () {
        describe('onAdd', function () {
            it('Should clear the error when all fields are filled in', function () {
                newDataValues.selectedAsset = {id: 24};
                newDataValues.selectedMonitorClass = {id: 19};
                $scope.error = "Something";
                $scope.onAdd();
                expect($scope.error).toEqual("");
            });

            it('Should make the service call with the data objects', function () {
                newDataValues.selectedSite = {id: 24};
                newDataValues.selectedMonitorClass = {id: 19};
                $scope.assetUniqueIdentifier = "WH7890"
                $scope.currentFieldLog.name = "Travis";
                $scope.currentReading.temperature = 678;
                $scope.onAdd();
                expect(dataInputServiceCreateSpy).toHaveBeenCalledWith(24, 19, "WH7890", {name: "Travis"}, {temperature: 678}, null, null);
            });

            it('Should update the readings by getting all the readings from the server after a successful create call', function () {
                newDataValues.selectedSite = {id: 24};
                newDataValues.selectedMonitorClass = {id: 19};
                $scope.currentFieldLog.name = "Travis";
                $scope.currentReading.temperature = 678;
                $scope.onAdd();
                expect(dataInputServiceReadingSpy).toHaveBeenCalledWith(24, 19);
            });

            it('Should show an error if no selectedSite is defined', function () {
                newDataValues.selectedSite = null;
                newDataValues.selectedMonitorClass = {id: 19};
                $scope.onAdd();
                expect($scope.error).toBeDefined();
                expect($scope.error).not.toEqual("");
            });

            it('Should show an error if no selectedMonitorClass is defined', function () {
                newDataValues.selectedSite = {id: 19};
                newDataValues.selectedMonitorClass = null;
                $scope.onAdd();
                expect($scope.error).toBeDefined();
                expect($scope.error).not.toEqual("");
            });
        });

        describe('onReset', function () {
            it('Should set the $scope.currentFieldLog to an empty object', function () {
                $scope.currentFieldLog = {name: "Steve"};
                $scope.onReset();
                expect($scope.currentFieldLog).toEqual({});
            });

            it('Should set the $scope.currentRading to an empty object', function () {
                $scope.currentReading = {name: "Steve"};
                $scope.onReset();
                expect($scope.currentReading).toEqual({});
            });
        });
    });

    describe('Getters', function () {
        describe('getMonitorLimitWarning', function () {
            beforeEach(function () {
                newDataValues.selectedSite =
                {"address": "Manse Road \r\nMyocum \r\n2481", "company_id": null, "country_id": 1, "created_at": "2013-05-30T15:16:51Z", "google_earth_file_content_type": null, "google_earth_file_file_name": null, "google_earth_file_file_size": null, "google_earth_file_updated_at": null, "id": 3, "lattitude": " 28\u00b035'22.36\"S", "longitude": "153\u00b030'44.22\"E", "site_name": "Myocum Landfill", "state_id": 53, "updated_at": "2013-05-30T15:16:51Z", "section_ids": [3, 4], "monitor_class_ids": [5], "monitor_limits": [
                    {"created_at": "2014-01-20T05:09:25Z", "id": 1, "location_id": 3, "lower_limit": "400", "monitor_point_id": 4, "updated_at": "2014-01-20T05:09:25Z", "upper_limit": "600", "monitor_point": {"created_at": "2013-11-27T02:48:33Z", "id": 4, "name": "Methane", "unit": "%", "updated_at": "2013-11-27T02:48:33Z"}}
                ]};
                $scope.$digest();
            });

            it('Should return a blank string if there is no key', function () {
                expect($scope.getMonitorLimitWarning(null, 500)).toEqual("");
            });

            it('Should return a blank string if there is no value', function () {
                expect($scope.getMonitorLimitWarning("methane", null)).toEqual("");
            });

            it('Should return a blank string if there is no newDataValues.selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect($scope.getMonitorLimitWarning("methane", 500)).toEqual("");
            });

            it('Should return the upper limit message if the value is above the upper limit', function () {
                expect($scope.getMonitorLimitWarning("Methane", "600.5")).toEqual("This value is above the upper limit of 600");
            });

            it('Should return the lower limit message if the value is below the lower limit', function () {
                expect($scope.getMonitorLimitWarning("Methane", "200")).toEqual("This value is below the lower limit of 400");
            });

            it('Should return no messsage if the value is dead on', function () {
                expect($scope.getMonitorLimitWarning("Methane", "400")).toEqual("");
            });

            it('Should return no message if the value is in the middle', function () {
                expect($scope.getMonitorLimitWarning("Methane", "500.5")).toEqual("");
            });
        });

        describe('getAssetAutoCompleteUrl', function () {
            it('Should return a version without either the site or monitor class', function () {
                expect($scope.getAssetAutoCompleteUrl()).toEqual(
                    new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS).build()
                );
            });

            it('Should return a version with the site', function () {
                expect($scope.getAssetAutoCompleteUrl({id: 27})).toEqual(
                    new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS).
                        paramReplace(":site_id", 27).
                        build()
                );
            });

            it('Should return a version with the monitor class', function () {
                expect($scope.getAssetAutoCompleteUrl(null, {id: 16})).toEqual(
                    new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS).
                        paramReplace(":monitor_class_id", 16).
                        build()
                );
            });

            it('Should return a version with both', function () {
                expect($scope.getAssetAutoCompleteUrl({id: 27}, {id: 16})).toEqual(
                    new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS).
                        paramReplace(":site_id", 27).
                        paramReplace(":monitor_class_id", 16).
                        build()
                );
            });
        });
    });


    describe('Initialization', function () {
        it('Should set currentFieldLog to an empty object', function () {
            expect($scope.currentFieldLog).toEqual({});
        });

        it('Should set currentReading to an empty object', function () {
            expect($scope.currentReading).toEqual({});
        });

        it('Should set $scope.newDataValues to newDataValues', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });
    });
});