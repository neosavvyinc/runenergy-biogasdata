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

    describe('Watchers', function () {
        it('Should set the newDataValues.selectedLandFillOperator to the first one in the list when it is initialized', function () {
            expect(newDataValues.selectedLandfillOperator).toBeNull();
            $scope.landfillOperators = ["Lemmy", "Ronnie James", "Ozzy"];
            $scope.$digest();
            expect(newDataValues.selectedLandfillOperator).toEqual("Lemmy");
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

        it('Should set assets to null', function () {
            expect($scope.assets).toBeNull();
        });

        it('Should set newDataValues to the values object', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });
    });
});