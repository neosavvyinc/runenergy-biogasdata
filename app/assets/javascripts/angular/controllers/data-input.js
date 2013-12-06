RunEnergy.Dashboard.Controllers.controller('controllers.DataInputController',
    ['$scope', 'values.DashboardHeaderData', 'values.NewDataValues', 'services.DataInputService',
        function ($scope, dashboardHeaderData, newDataValues, dataInputService) {

            //Initialization
            $scope.currentFieldLog = {};
            $scope.currentReading = {};
            $scope.newDataValues = newDataValues;

            //Watchers
            function _getReadings() {
                if (newDataValues.selectedAsset && newDataValues.selectedMonitorClass) {

                }
            }

            $scope.$watch('newDataValues.selectedAsset', _getReadings);
            $scope.$watch('newDataValues.selectedMonitorClass', _getReadings);

            //Action Handlers
            $scope.onAdd = function() {

            };

            $scope.onReset = function() {

            };

        }]);