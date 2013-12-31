describe("controllers.DataAnalysisTable", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller,
        readingsSpy;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            readingsSpy = spyOnAngularService($injector.get('services.AnalysisService'), 'readings', {readings: [
                {data: {age: 5}},
                {data: {age: 6}}
            ]});
            controller = $injector.get('$controller')("controllers.DataAnalysisTable", {$scope: $scope});
        });
    });

    describe('Watchers', function () {
        describe('newDataValues.selectedLandfillOperator', function () {
            beforeEach(function () {
                newDataValues.selectedLandfillOperator = {id: 11};
            });

            it('Should do nothing if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect(readingsSpy).not.toHaveBeenCalled();
            });

            it('Should get the readings with the ids from the selections', function () {
                newDataValues.selectedSite = {id: 45};
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(11, 45, undefined, undefined);
            });
        });

        describe('newDataValues.selectedSite', function () {
            it('Should do nothing if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect(readingsSpy).not.toHaveBeenCalled();
            });

            it('Should get the readings with the ids from the selections', function () {
                newDataValues.selectedSite = {id: 84};
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(undefined, 84, undefined, undefined);
            });
        });

        describe('newDataValues.selectedSection', function () {
            beforeEach(function () {
                newDataValues.selectedSection = {id: 78};
            });

            it('Should do nothing if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect(readingsSpy).not.toHaveBeenCalled();
            });

            it('Should get the readings with the ids from the selections', function () {
                newDataValues.selectedSite = {id: 45};
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(undefined, 45, 78, undefined);
            });
        });

        describe('data', function () {
            it('Should not set filters if the data does not have length', function () {
                $scope.data = [];
                $scope.$digest();
                expect($scope.filters).toBeUndefined();
            });

            it('Should set the filters with the first item of the data', function () {
                $scope.data = [{name: 56, age: 38}];
                $scope.$digest();
                expect($scope.filters).toEqual({name: "", age: ""});
            });
        });

        afterEach(function () {
            newDataValues.selectedLandfillOperator = null;
            newDataValues.selectedSite = null;
            newDataValues.selectedSection = null;
            newDataValues.selectedAsset = null;
        })
    });

    describe('Initialization', function () {
        it('Should set the data property on scope to an empty array', function () {
            expect($scope.data).toEqual([]);
        });

        it('Should instantiate page to 0', function () {
            expect($scope.page).toEqual(0);
        });

        it('Should add newDataValues to the $scope', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });
    });
});