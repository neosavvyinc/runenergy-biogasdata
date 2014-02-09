describe("controllers.UpperLimit", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.UpperLimit", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set the limitKey to lower_limit', function () {
            expect($scope.limitKey).toEqual('upper_limit');
        });

        it('Should set $scope.data to an empty array', function () {
            expect($scope.data).toEqual([]);
        });
    });

    describe('Watchers', function () {

        describe('upperLimits', function () {
            it('Should watch upperLimits and set $scope.data to the val if it changes', function () {
                $scope.upperLimits = [1,2,3];
                $scope.$digest();
                expect($scope.data).toEqual($scope.upperLimits);
            });
        });

    });

    describe('Getters', function () {

        it('Should return nothing if the value is blank', function () {
            expect($scope.getOutsideLimitClass(null, {upper_limit: 15})).toEqual('');
        });

        it('Should return a blank string if the monitorLimit has no upper_limit', function () {
            expect($scope.getOutsideLimitClass(5, {})).toEqual('');
        });

        it('Should return blank if the value is below the upper_limit', function () {
            expect($scope.getOutsideLimitClass(5, {upper_limit: 15})).toEqual('');
        });

        it('Should return outside string if the value is above the upper_limit', function () {
            expect($scope.getOutsideLimitClass(20, {upper_limit: 15})).toEqual('outside');
        });

    });

});