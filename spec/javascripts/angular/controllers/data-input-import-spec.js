describe("controllers.DataInputImportController", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.DataInputImportController", {$scope: $scope});
        });
    });
});