RunEnergy.Dashboard.Controllers.controller('controllers.CreateMonitorPoint',
    ['$scope',
        'services.DataInputService',
        'values.NewDataValues',
        function ($scope,
                  dataInputService,
                  newDataValues) {

            $scope.onCreateMonitorPoint = function (valid) {
                if (valid) {
                    dataInputService.createMonitorPoint(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id,
                            $scope.name,
                            $scope.unit).then(function (result) {
                            newDataValues.selectedMonitorClass.monitor_points_for_all_locations =
                                newDataValues.selectedMonitorClass.monitor_points_for_all_locations || [];

                            //Add new monitor point to collection shown in dropdowns
                            newDataValues.selectedMonitorClass.monitor_points_for_all_locations.push(result);
                            newDataValues.monitorPoints.push(result);

                            $scope.name = "";
                            $scope.unit = "";
                        });
                }
            };

            $scope.name = "";
            $scope.unit = "";
            $scope.newDataValues = newDataValues;

        }]);