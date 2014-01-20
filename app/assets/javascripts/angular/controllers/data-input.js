RunEnergy.Dashboard.Controllers.controller('controllers.DataInputController',
    ['$scope', 'values.DashboardHeaderData', 'values.NewDataValues', 'services.DataInputService', 'constants.Routes',
        function ($scope, dashboardHeaderData, newDataValues, dataInputService, routes) {

            //Initialization
            $scope.currentFieldLog = {};
            $scope.currentReading = {};
            $scope.newDataValues = newDataValues;
            $scope.assetUniqueIdentifier = "";
            $scope.data = [];
            $scope.readingDate = null;
            $scope.readingTime = null;

            //Watchers
            function _getReadings() {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
                    dataInputService.readings(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id
                        ).then(function (result) {
                            $scope.data = _.map(result, 'data');
                        });
                }
            }

            $scope.$watch('newDataValues.selectedSite', _getReadings);
            $scope.$watch('newDataValues.selectedMonitorClass', _getReadings);

            //Getters
            $scope.getAssetAutoCompleteUrl = memoize(function(selectedSite, selectedMonitorClass) {
                var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS);
                if (selectedSite) {
                    builder.paramReplace(':site_id', selectedSite.id);
                }
                if (selectedMonitorClass) {
                    builder.paramReplace(':monitor_class_id', selectedMonitorClass.id);
                }
                return builder.build();
            });

            //Action Handlers
            function _allValues(map) {
                if (map) {
                    for (var key in map) {
                        if (Neosavvy.Core.Utils.StringUtils.isBlank(map[key])) {
                            return false;
                        }
                    }
                    return true;
                }
                return false;
            }

            $scope.onAdd = function () {
                if (newDataValues.selectedSite &&
                    newDataValues.selectedMonitorClass) {
                    $scope.error = "";
                    dataInputService.createReading(
                        newDataValues.selectedSite.id,
                        newDataValues.selectedMonitorClass.id,
                        $scope.assetUniqueIdentifier,
                        $scope.currentFieldLog,
                        $scope.currentReading,
                        $scope.readingDate,
                        $scope.readingTime).then(_getReadings);
                } else {
                    $scope.error = "Please fill in all fields for the reading.";
                }
            };

            $scope.onReset = function () {
                $scope.currentFieldLog = {};
                $scope.currentReading = {};
            };

        }]);