describe("controllers.ImportTable", function () {
    var $rootScope,
        $scope,
        $controller,
        controller;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector, _$controller_) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            $controller = _$controller_;

            //$Scope values
            $scope.readingMods = {
                deletedRowIndices: [],
                deletedColumns: [],
                columnToMonitorPointMappings: {}
            };


            controller = $controller("controllers.ImportTable", {$scope: $scope});
        });
    });

    it('Should throw an error if readingMods is not defined on the $scope', function () {
        expect(function () {
            $controller("controllers.ImportTable", {$scope: $rootScope.$new()});
        }).toThrow();
    });

    describe('Action Handlers', function () {
        describe('onRemoveRow', function () {
            it('Should add the row index to the readingMods.deletedRowIndices', function () {
                expect($scope.readingMods.deletedRowIndices).not.toContain(89);
                $scope.onRemoveRow(89);
                expect($scope.readingMods.deletedRowIndices).toContain(89);
            });

            it('Should remove the row index from the readingMods.deletedRowIndices if it is already there', function () {
                $scope.readingMods.deletedRowIndices = [68];
                $scope.onRemoveRow(68);
                expect($scope.readingMods.deletedRowIndices).not.toContain(68);
            });
        });

        describe('onRemoveColumn', function () {

        });
    });
});