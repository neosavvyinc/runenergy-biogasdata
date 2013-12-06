describe("controllers.DataInputController", function () {
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
            controller = $injector.get('$controller')("controllers.DataInputController", {$scope: $scope});
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