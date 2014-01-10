describe("controllers.ImportTable", function () {
    var $rootScope,
        $scope,
        $controller,
        newDataValues,
        analysisServiceSpy,
        controller;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector, _$controller_) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            $controller = _$controller_;
            newDataValues = $injector.get('values.NewDataValues');
            analysisServiceSpy = spyOnAngularService($injector.get('services.AnalysisService'), 'monitorPoints', {monitor_points: [6, 7, 8]});

            //$Scope values
            $scope.readingMods = {
                deletedRowIndices: [],
                deletedColumns: {},
                columnToMonitorPointMappings: {}
            };


            controller = $controller("controllers.ImportTable", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should throw an error if readingMods is not defined on the $scope', function () {
            expect(function () {
                $controller("controllers.ImportTable", {$scope: $rootScope.$new()});
            }).toThrow();
        });

        it('Should define newDataValues on the $scope', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });
    });

    describe('Watchers', function () {
        describe('newDataValues.selectedAsset', function () {
            it('Should not call the service if the asset is null', function () {
                newDataValues.selectedAsset = false;
                $scope.$digest();
                expect(analysisServiceSpy).not.toHaveBeenCalled();
            });

            it('Should not call the service if the asset does not have an id', function () {
                newDataValues.selectedAsset = {name: "Charlie"};
                $scope.$digest();
                expect(analysisServiceSpy).not.toHaveBeenCalled();
            });

            it('Should call the service with the asset id', function () {
                newDataValues.selectedAsset = {id: 17};
                $scope.$digest();
                expect(analysisServiceSpy).toHaveBeenCalledWith(17);
            });

            it('Should set $scope.monitorPoints to the result of the service call', function () {
                newDataValues.selectedAsset = {id: 17};
                $scope.$digest();
                expect($scope.monitorPoints).toEqual([6, 7, 8]);
            });
        });
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
            it('Should add the column to the the readingMods.deletedColumns hash with a true value', function () {
                expect($scope.readingMods.deletedColumns["Jerry"]).toBeUndefined();
                $scope.onRemoveColumn("Jerry");
                expect($scope.readingMods.deletedColumns["Jerry"]).toBeTruthy();
            });

            it('Should remove the key from the readingMods.deletedColums hash if it exists', function () {
                $scope.readingMods.deletedColumns["Georgie"] = true;
                $scope.onRemoveColumn("Georgie");
                expect($scope.readingMods.deletedColumns["Georgie"]).toBeUndefined();
            });
        });
    });

    describe('Getters', function () {
        describe('getRowVariation', function () {
            it('Should return optionA when deletedRowIndices does not have the index in question', function () {
                $scope.readingMods.deletedRowIndices = [14,68];
                expect($scope.getRowVariation(15, "Short", "Tall")).toEqual("Short");
            });

            it('Should return optionB in the other case', function () {
                $scope.readingMods.deletedRowIndices = [14,68];
                expect($scope.getRowVariation(14, "Strawberry", "Blackberry")).toEqual("Blackberry");
            });
        });

        describe('getColumnVariation', function () {
            it('Should return optionA when deletedColumns does not contain the name specified', function () {
                $scope.readingMods.deletedColumns = {
                    'Charles': true
                };
                expect($scope.getColumnVariation("Georgie", "Running", "Canoeing")).toEqual("Running");
            });

            it('Should return optionB in the other case', function () {
                $scope.readingMods.deletedColumns = {
                    'Charles': true,
                    'Georgie': true
                };
                expect($scope.getColumnVariation("Georgie", 54, 46)).toEqual(46);
            });
        });
    });
});