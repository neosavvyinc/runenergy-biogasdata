describe("controllers.DataCollision", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.DataCollision", {$scope: $scope});
        });
    });
});