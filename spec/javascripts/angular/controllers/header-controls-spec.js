describe("controllers.HeaderControlsController", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.HeaderControlsController", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should initialize the dataInputViews as follows', function () {
            expect($scope.dataInputViews).toEqual([
                "Add Data",
                "Import Data"
            ]);
        });
    });
});