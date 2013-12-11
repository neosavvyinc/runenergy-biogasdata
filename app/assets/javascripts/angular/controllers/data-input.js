RunEnergy.Dashboard.Controllers.controller('controllers.DataInputController',
    ['$scope', 'values.DashboardHeaderData', 'values.NewDataValues', 'services.DataInputService',
        function ($scope, dashboardHeaderData, newDataValues, dataInputService) {

            //Initialization
            $scope.currentFieldLog = {};
            $scope.currentReading = {};
            $scope.newDataValues = newDataValues;
            $scope.readings = [];

            //Watchers
            function _getReadings() {
                if (newDataValues.selectedAsset && newDataValues.selectedMonitorClass) {
                    $scope.readings = dataInputService.readings(newDataValues.selectedAsset.id, newDataValues.selectedMonitorClass.id);
                }
            }

            $scope.$watch('newDataValues.selectedAsset', _getReadings);
            $scope.$watch('newDataValues.selectedMonitorClass', _getReadings);

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
                if (newDataValues.selectedAsset && newDataValues.selectedMonitorClass &&
                    _allValues($scope.currentFieldLog) && _allValues($scope.currentReading)) {
                    $scope.error = "";
                    dataInputService.createReading(
                        newDataValues.selectedAsset.id,
                        newDataValues.selectedMonitorClass.id,
                        $scope.currentFieldLog,
                        $scope.currentReading).then(_getReadings);
                } else {
                    $scope.error = "Please fill in all fields for the reading.";
                }
            };

            $scope.onReset = function () {

            };

        }]);