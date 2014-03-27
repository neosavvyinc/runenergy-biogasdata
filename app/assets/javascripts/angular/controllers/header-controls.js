RunEnergy.Dashboard.Controllers.controller('controllers.HeaderControlsController',
    ['$scope', 'values.NewDataValues',
        function ($scope, newDataValues) {
            //Getters
            var _buildParameterized = function (base) {
                try {
                    var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(base);
                    if (newDataValues.selectedLandfillOperator) {
                        builder.addParam("operator", newDataValues.selectedLandfillOperator.id);
                    }
                    if (newDataValues.selectedSite) {
                        builder.addParam("site", newDataValues.selectedSite.id);
                    }
                    if (newDataValues.selectedMonitorClass) {
                        builder.addParam("monitor_class", newDataValues.selectedMonitorClass.id);
                    }
                    if (newDataValues.selectedSection) {
                        builder.addParam("section", newDataValues.selectedSection.id);
                    }
                    if (newDataValues.selectedAsset) {
                        builder.addParam("asset", newDataValues.selectedAsset.id);
                    }
                    return builder.build();
                } catch (e) {
                    return base;
                }
            };

            $scope.getDataImportLink = function () {
                return _buildParameterized('/data_input/import#');
            };

            $scope.getDataCreateLink = function () {
                return _buildParameterized('/data_input/create#');
            };

            $scope.getDataAnalysisLink = function () {
                return _buildParameterized("/data_analysis#");
            };

            $scope.getExportCsvLink = function () {
                var builder = new Neosavvy.Core.Builders.RequestUrlBuilder("data_analysis/export/readings/site/:site_id/monitorclass/:monitor_class_id.csv");
                if (newDataValues.selectedSite) {
                    builder.paramReplace(":site_id", newDataValues.selectedSite.id)
                }
                if (newDataValues.selectedMonitorClass) {
                    builder.paramReplace(":monitor_class_id", newDataValues.selectedMonitorClass.id)
                }
                if (newDataValues.selectedSection) {
                    builder.addParam("section_id", newDataValues.selectedSection.id);
                }
                if (newDataValues.selectedAsset) {
                    builder.addParam("asset_id", newDataValues.selectedAsset.id);
                }
                return builder.build();
            };


            //Initialization
            $scope.dataInputViews = [
                "Add Data",
                "Import Data"
            ];

        }]);