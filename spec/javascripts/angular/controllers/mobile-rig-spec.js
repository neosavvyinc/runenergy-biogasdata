describe("controllers.MobileRigController", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.MobileRigController", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should instantiate monitorClasses to null', function () {
            expect($scope.monitorClasses).toBeNull();
        });
    });
});
