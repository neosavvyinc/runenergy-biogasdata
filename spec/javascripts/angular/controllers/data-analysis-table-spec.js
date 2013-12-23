describe("controllers.DataAnalysisTable", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            controller = $injector.get('$controller')("controllers.DataAnalysisTable", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set the data property on scope to an empty array', function () {
            expect($scope.data).toEqual([]);
        });

        it('Should instantiate page to 0', function () {
            expect($scope.page).toEqual(0);
        });

        it('Should add newDataValues to the $scope', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });
    });
});