describe("controllers.DataAnalysisTable", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.DataAnalysisTable", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set the data property on scope to an empty array', function () {
            expect($scope.data).toEqual([]);
        });
    });
});