describe("controllers.DataInputImportController", function () {
    var $rootScope,
        $scope,
        controller,
        newDataValues,
        readingTransformerSpy,
        createTransformerSpy,
        completeImportCsvSpy;

    beforeEach(module('runenergy.dashboard.controllers', function ($provide) {
        readingTransformerSpy = jasmine.createSpy().andReturn("Jimminy Crickets!");
        createTransformerSpy = jasmine.createSpy().andReturn("Jimminy Createkits!");
        $provide.value('services.transformer.UniversalReadingResponseTransformer', readingTransformerSpy);
        $provide.value('services.transformer.DataInputCreateTransformer', createTransformerSpy);
    }));

    beforeEach(function () {
        module.apply(this, [
            'runenergy.dashboard.controllers',
            'runenergy.dashboard.services',
            'runenergy.dashboard.constants',
            'runenergy.dashboard.values'
        ].concat(Neosavvy.AngularCore.Dependencies));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            completeImportCsvSpy = spyOn($injector.get('services.DataInputService'), 'completeImportCsv').
            andReturn({then: function (fn) {
                    fn([1, 2, 3]);
                    return {finally: function (fnb) {
                        fnb();
                    }}
                }});
            controller = $injector.get('$controller')("controllers.DataInputImportController", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set $scope.columnNameRow to 1', function () {
            expect($scope.columnNameRow).toEqual(1);
        });

        it('Should set $scope.firstDataRow to 2', function () {
            expect($scope.firstDataRow).toEqual(2);
        });

        it('Should instantiate $scope.readingMods', function () {
            expect($scope.readingMods).toEqual({
                deletedRowIndices: [],
                deletedColumns: {},
                columnToMonitorPointMappings: {},
                assetColumnName: null
            });
        });

        it('Should instantiate newDataValues as a property on the scope', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });

        it('Should instantiate approvals', function () {
            expect($scope.approvals).toEqual({
                upperLimit: false,
                lowerLimit: false
            });
        });
    });

    describe('Watchers', function () {

        describe('data', function () {
            it('Should not call the reading transformer or set the data on the scope with an empty return', function () {
                $scope.data = null;
                $scope.$digest();
                expect(readingTransformerSpy).not.toHaveBeenCalled();
            });

            it('Should call the readingTransformer with the data', function () {
                $scope.data = [1, 2, 3, 4];
                $scope.$digest();
                expect(readingTransformerSpy).toHaveBeenCalledWith([1, 2, 3, 4]);
            });

            it('Should set the transformed data on the scope', function () {
                $scope.data = [1, 2, 3, 4];
                $scope.$digest();
                expect($scope.data).toEqual("Jimminy Crickets!");
            });
        });

        describe('columnNameRow, firstDataRow', function () {
            it('Should set $scope.requiredFieldsMissing to true when columnNameRow is blank on the scope', function () {
                $scope.firstDataRow = 25;
                $scope.columnNameRow = null;
                $scope.$digest();
                expect($scope.requiredFieldsMissing).toBeTruthy();
            });

            it('Should set $scope.requiredFieldsMissing to true when firstDataRow is blank on the scope', function () {
                $scope.columnNameRow = 13;
                $scope.firstDataRow = null;
                $scope.$digest();
                expect($scope.requiredFieldsMissing).toBeTruthy();
            });

            it('Should set $scope.requiredFieldsMissing to false when neither is blank on the scope', function () {
                $scope.firstDataRow = 25;
                $scope.columnNameRow = 13;
                $scope.$digest();
                expect($scope.requiredFieldsMissing).toBeFalsy();
            });
        });

        describe('newDataValues.selectedLocationsMonitorClass', function () {

            it('Should set the $scope.readingMods.columnToMonitorPointMappings when the value is set', function () {
                expect($scope.readingMods.columnToMonitorPointMappings).toEqual({});
                newDataValues.selectedLocationsMonitorClass = {column_cache: {name: 'George', age: 42}};
                $scope.$digest();
                expect($scope.readingMods.columnToMonitorPointMappings).toEqual({name: 'George', age: 42});
            });

            it('Should set the $scope.deletedColumns when the value is set', function () {
                expect($scope.readingMods.deletedColumns).toEqual({});
                newDataValues.selectedLocationsMonitorClass = {deleted_column_cache: {name: true, color: true}};
                $scope.$digest();
                expect($scope.readingMods.deletedColumns).toEqual({name: true, color: true});
            });
        });
    });

    describe('Action Handlers', function () {
        describe('onCompleteImport', function () {
            it('Should call the completeImportCsv method on the service with the params', function () {
                $scope.data = [{id: 0, $$hashKey: 19}, {id: 2, $$hashKey: 20}, {id: 3, $$hashKey: 21}];
                $scope.readingMods.assetColumnName = 'id';
                $scope.onCompleteImport();
                expect(completeImportCsvSpy).toHaveBeenCalledWith(
                    [{id: 0, $$hashKey: 19}, {id: 2, $$hashKey: 20}, {id: 3, $$hashKey: 21}],
                    $scope.readingMods.columnToMonitorPointMappings,
                    $scope.readingMods.deletedRowIndices,
                    $scope.readingMods.deletedColumns,
                    undefined,
                    17,
                    'id');
            });

            it('Should set $scope.data to null', function () {
                $scope.data = [{id: 0, $$hashKey: 19}, {id: 2, $$hashKey: 20}, {id: 3, $$hashKey: 21}];
                $scope.readingMods.assetColumnName = 'id';
                $scope.onCompleteImport();
                expect($scope.data).toBeNull();
            });
        });

        describe('onSetAssetColumn', function () {
            it('Should set the $scope.readingMods.assetColumnName to the column passed into the function', function () {
                expect($scope.readingMods.assetColumnName).toBeNull();
                $scope.onSetAssetColumn("Identifier 20");
                expect($scope.readingMods.assetColumnName).toEqual("Identifier 20");
            });
        });

        describe('onSubmit', function () {
            var eSpy;

            beforeEach(function () {
                newDataValues.selectedSite = {id: 29};
                newDataValues.selectedMonitorClass = {id: 25};
                eSpy = jasmine.createSpyObj('e', ['preventDefault']);
            });

            it('Should preventDefault of event if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.onSubmit(eSpy);
                expect(eSpy.preventDefault).toHaveBeenCalledWith();
            });

            it('Should set $scope.error if there is no selected site', function () {
                newDataValues.selectedSite = null;
                $scope.onSubmit(eSpy);
                expect($scope.error).toEqual('You must select a site before uploading');
            });

            it('Should preventDefault of event if there is no selectedMonitorClass', function () {
                newDataValues.selectedMonitorClass = null;
                $scope.onSubmit(eSpy);
                expect(eSpy.preventDefault).toHaveBeenCalledWith();
            });

            it('Should set $scope.error if there is no selected monitor class', function () {
                newDataValues.selectedMonitorClass = null;
                $scope.onSubmit(eSpy);
                expect($scope.error).toEqual('You must select a monitor class before uploading');
            });

            it('Should not prevent the default if there is both', function () {
                $scope.onSubmit(eSpy);
                expect(eSpy.preventDefault).not.toHaveBeenCalled();
            });

        });
    });

    describe('Getters', function () {
        describe('getFormPostUrl', function () {
            beforeEach(function () {
                newDataValues.selectedLandfillOperator = {id: 15};
                newDataValues.selectedSite = {id: 16};
                newDataValues.selectedMonitorClass = {id: 17};
                newDataValues.selectedSection = {id: 18};
                newDataValues.selectedAsset = {id: 21};
            });

            it('Should return the base url with all the params', function () {
                expect($scope.getFormPostUrl('/data_input/import', newDataValues)).toEqual('/data_input/import?operator=15&site=16&monitor_class=17&section=18&asset=21');
            });
        });
    });
});