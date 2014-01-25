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

    describe('Getters', function () {
        describe('getColumnLabel', function () {
            it('Should return undefined when passed undefined for the key', function () {
                expect($scope.getColumnLabel(undefined, "%")).toBeUndefined();
            });

            it('Should return the key when passed null for the key', function () {
                expect($scope.getColumnLabel(null, "pH")).toBeNull();
            });

            it('Should return the key when passed a blank string for the key', function () {
                expect($scope.getColumnLabel("", "Oz.")).toEqual("");
            });

            it('Should return just the key', function () {
                expect($scope.getColumnLabel("Methane", null)).toEqual("Methane");
            });

            it('Should return the key plus the units if defined', function () {
                expect($scope.getColumnLabel("Methane", {unit: "%"})).toEqual("Methane (%)");
            });
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
                newDataValues.selectedMonitorClass = {id: 11};
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 11, null, null);
            });

            it('Should call with the startDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, $scope.startDateTime, null);
            });

            it('Should call with the endDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.endDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, null, $scope.endDateTime);
            });

            it('Should call with both the start and end dates if they are available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.endDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, $scope.startDateTime, $scope.endDateTime);
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
                newDataValues.selectedMonitorClass = {id: 14};
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(84, 14, null, null);
            });

            it('Should call with the startDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, $scope.startDateTime, null);
            });

            it('Should call with the endDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.endDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, null, $scope.endDateTime);
            });

            it('Should call with both the start and end dates if they are available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.endDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, $scope.startDateTime, $scope.endDateTime);
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
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, null, null);
            });

            it('Should call with the startDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, $scope.startDateTime, null);
            });

            it('Should call with the endDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.endDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, null, $scope.endDateTime);
            });

            it('Should call with both the start and end dates if they are available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.endDateTime = new Date();
                $scope.$digest();
                expect(readingsSpy).toHaveBeenCalledWith(45, 17, $scope.startDateTime, $scope.endDateTime);
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

        it('Should set $scope.monitorPoints to an empty array', function () {
            expect($scope.monitorPoints).toEqual([]);
        });

        it('Should set startDateTime to null', function () {
            expect($scope.startDateTime).toBeNull();
        });

        it('Should set endDateTime to null', function () {
            expect($scope.endDateTime).toBeNull();
        });
    });
});