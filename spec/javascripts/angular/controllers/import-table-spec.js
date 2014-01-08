describe("controllers.ImportTable", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.ImportTable", {$scope: $scope});
        });
    });
});