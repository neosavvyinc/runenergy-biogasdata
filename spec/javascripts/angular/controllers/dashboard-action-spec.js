describe("controllers.DashboardActionController", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            controller = $injector.get('$controller')("controllers.DashboardActionController", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set landfillOperators to null', function () {
            expect($scope.landfillOperators).toBeNull();
        });

        it('Should set sites to null', function () {
            expect($scope.sites).toBeNull();
        });

        it('Should set monitorClasses to null', function () {
            expect($scope.monitorClasses).toBeNull();
        });

        it('Should set sections to null', function () {
            expect($scope.sections).toBeNull();
        });

        it('Should set newDataValues to the values object', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });
    });
});