describe("controllers.LowerLimit", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.LowerLimit", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set the limitKey to lower_limit', function () {
            expect($scope.limitKey).toEqual('lower_limit');
        });

        it('Should set $scope.data to an empty array', function () {
            expect($scope.data).toEqual([]);
        });
    });

    describe('Watchers', function () {

        describe('lowerLimits', function () {
            it('Should watch lowerLimits and set $scope.data to the val if it changes', function () {
                $scope.lowerLimits = [1,2,3];
                $scope.$digest();
                expect($scope.data).toEqual($scope.lowerLimits);
            });
        });

    });

    describe('Getters', function () {

        it('Should return nothing if the value is blank', function () {
            expect($scope.getOutsideLimitClass(null, {lower_limit: 15})).toEqual('');
        });

        it('Should return a blank string if the monitorLimit has no lower_limit', function () {
            expect($scope.getOutsideLimitClass(5, {})).toEqual('');
        });

        it('Should return outside if the value is below the lower_limit', function () {
            expect($scope.getOutsideLimitClass(5, {lower_limit: 15})).toEqual('outside');
        });

        it('Should return a blank string if the value is above the lower_limit', function () {
            expect($scope.getOutsideLimitClass(20, {lower_limit: 15})).toEqual('');
        });

    });
});