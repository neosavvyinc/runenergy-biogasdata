describe("controllers.CreateMonitorPoint", function () {
    var $rootScope,
        $scope,
        newDataValues,
        createMonitorPointSpy,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            createMonitorPointSpy = spyOnAngularService($injector.get('services.DataInputService'), 'createMonitorPoint', {id: 55});
            controller = $injector.get('$controller')("controllers.CreateMonitorPoint", {$scope: $scope});
        });
    });

    describe('Action Handlers', function () {
        describe('onCreateMonitorPoint', function () {
            beforeEach(function () {
                newDataValues.selectedSite = {id: 15};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.name = "Methane";
                $scope.unit = "lb.";
            });

            it('Should call nothing if the form is invalid', function () {
                $scope.onCreateMonitorPoint(false);
                expect(createMonitorPointSpy).not.toHaveBeenCalled();
            });

            it('Should call the service if the form is valid', function () {
                $scope.onCreateMonitorPoint(true);
                expect(createMonitorPointSpy).toHaveBeenCalledWith(15, 17, "Methane", "lb.");
            });

            it('Should set monitor_points_for_all_locations', function () {
                $scope.onCreateMonitorPoint(true);
                expect(newDataValues.selectedMonitorClass.monitor_points_for_all_locations).toEqual([{id: 55}]);
            });

            it('Should blank out the $scope.name', function () {
                $scope.onCreateMonitorPoint(true);
                expect($scope.name).toEqual("");
            });

            it('Should blank out the $scope.unit', function () {
                $scope.onCreateMonitorPoint(true);
                expect($scope.unit).toEqual("");
            });
        });
    });

    describe('Initialization', function () {
        it('Should set $scope.name to a blank string', function () {
            expect($scope.name).toEqual("");
        });

        it('Should set $scope.unit to a blank string', function () {
            expect($scope.unit).toEqual("");
        });
    });

});