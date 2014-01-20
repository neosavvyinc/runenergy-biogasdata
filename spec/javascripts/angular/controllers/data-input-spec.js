describe("controllers.DataInputController", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller,
        dataInputServiceCreateSpy,
        dataInputServiceReadingSpy;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
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