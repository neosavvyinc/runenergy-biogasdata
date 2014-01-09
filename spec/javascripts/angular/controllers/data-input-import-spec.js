describe("controllers.DataInputImportController", function () {
    var $rootScope,
        $scope,
        controller,
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
            'runenergy.dashboard.constants'
        ].concat(Neosavvy.AngularCore.Dependencies));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            completeImportCsvSpy = spyOnAngularService($injector.get('services.DataInputService'), 'completeImportCsv', [1, 2, 3]);
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
                columnToMonitorPointMappings: {}
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

    });

    describe('Action Handlers', function () {
        describe('onCompleteImport', function () {
            it('Should call the completeImportCsv method on the service with the params', function () {
                $scope.data = [1, 2, 3, 4];
                $scope.onCompleteImport();
                expect(completeImportCsvSpy).toHaveBeenCalledWith($scope.data, $scope.readingMods.columnToMonitorPointMappings, $scope.readingMods.deletedRowIndices, $scope.readingMods.deletedColumns);
            });
        });
    });
});