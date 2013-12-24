describe("controllers.HeaderControlsController", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            controller = $injector.get('$controller')("controllers.HeaderControlsController", {$scope: $scope});
        });
    });

    describe('Getters', function () {
        describe('getDataAnalysisLink', function () {

            beforeEach(function () {
                newDataValues.selectedLandfillOperator = null;
                newDataValues.selectedSite = null;
                newDataValues.selectedMonitorClass = null;
                newDataValues.selectedSection = null;
                newDataValues.selectedAsset = null;
            });

            it('Should just return the hashed link if there are no newDataValues', function () {
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#");
            });

            it('Should add the operator param when defined', function () {
                newDataValues.selectedLandfillOperator = {id: 17};
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#?operator=17");
            });

            it('Should add the site param when defined', function () {
                newDataValues.selectedSite = {id: 82};
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#?site=82");
            });

            it('Should add the monitor_class param when defined', function () {
                newDataValues.selectedMonitorClass = {id: 14};
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#?monitor_class=14");
            });

            it('Should add the site param when defined', function () {
                newDataValues.selectedSection = {id: 4};
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#?section=4");
            });

            it('Should add the asset param when defined', function () {
                newDataValues.selectedAsset = {id: 10};
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#?asset=10");
            });
        });
    });

    describe('Initialization', function () {
        it('Should initialize the dataInputViews as follows', function () {
            expect($scope.dataInputViews).toEqual([
                "Add Data",
                "Import Data"
            ]);
        });
    });
});