describe("controllers.visualizations.MonitorPointProgress", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("controllers.visualizations.MonitorPointProgress", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should instantiate date to an array containing an empty object', function () {
            expect($scope.data).toEqual([{}]);
        });
    });

    describe('Watchers', function () {
        beforeEach(function () {
            $scope.monitorPoint = {id: 26, name: 'Oxygen'};
            $scope.values = [1, 2, 3];
            $scope.$digest();
        });

        describe('monitorPoint', function () {
            it('Should watch the monitorPoint object on the scope and set the data[0].key to the name', function () {
                expect($scope.data[0].key).toEqual('Oxygen');
            });

            it('Should de-register this watcher', function () {
                $scope.monitorPoint = {id: 27, name: 'Carbon'};
                $scope.$digest();
                expect($scope.data[0].key).toEqual('Oxygen');
            });
        });

        describe('monitorPoint', function () {
            it('Should watch the values array on the scope and set the data[0].values to the val', function () {
                expect($scope.data[0].values).toEqual($scope.values);
            });

            it('Should de-register this watcher', function () {
                $scope.values = [4, 5, 6];
                $scope.$digest();
                expect($scope.data[0].values).toEqual([1, 2, 3]);
            });
        });
    });
});