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
    beforeEach(function () {
        this.addMatchers({
           containsUrlParam: function (base, param) {
               return (this.actual === (base + "?" + param));
           }
        });
    });

    describe('Getters', function () {
        describe('getDataAnalysisLink, getDataCreateLink, getDataImportLink', function () {

            beforeEach(function () {
                newDataValues.selectedLandfillOperator = null;
                newDataValues.selectedSite = null;
                newDataValues.selectedMonitorClass = null;
                newDataValues.selectedSection = null;
                newDataValues.selectedAsset = null;
            });

            it('Should just return the hashed link if there are no newDataValues', function () {
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#");
                expect($scope.getDataCreateLink()).toEqual("/data_input/create#");
                expect($scope.getDataImportLink()).toEqual("/data_input/import#");
            });

            it('Should add the operator param when defined', function () {
                newDataValues.selectedLandfillOperator = {id: 17};
                expect($scope.getDataAnalysisLink()).toEqual("/data_analysis#?operator=17");
            });

            it('Should add the site param when defined', function () {
                newDataValues.selectedSite = {id: 82};
                expect($scope.getDataAnalysisLink()).containsUrlParam("/data_analysis#", "site=82");
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

        describe('getExportCsvLink', function () {

            beforeEach(function () {
                newDataValues.selectedSite = {id: 8467};
                newDataValues.selectedMonitorClass = {id: 684};
                newDataValues.selectedSection = null;
                newDataValues.selectedAsset = null;
            });

            it('Should return the empty url when none of the params are available', function () {
                newDataValues.selectedSite = null;
                newDataValues.selectedMonitorClass = null;
                expect($scope.getExportCsvLink()).toEqual("data_analysis/export/readings/site/:site_id/monitorclass/:monitor_class_id.csv");
            });

            it('Should replace the site_id and monitor_class ids if that is available', function () {
                expect($scope.getExportCsvLink()).toEqual("data_analysis/export/readings/site/8467/monitorclass/684.csv");
            });

            it('Should add the section_id if that is available', function () {
                newDataValues.selectedSection = {id: 187};
                expect($scope.getExportCsvLink()).toEqual("data_analysis/export/readings/site/8467/monitorclass/684.csv?section_id=187");
            });

            it('Should add the asset_id if that is available', function () {
                newDataValues.selectedAsset = {id: 1666};
                expect($scope.getExportCsvLink()).toEqual("data_analysis/export/readings/site/8467/monitorclass/684.csv?asset_id=1666");
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