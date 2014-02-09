RunEnergy.Dashboard.Controllers.controller('controllers.CreateMonitorPoint',
    ['$scope',
        'services.DataInputService',
        'values.NewDataValues',
        '$timeout',
        function ($scope,
                  dataInputService,
                  newDataValues,
                  $timeout) {

            $scope.onCreateMonitorPoint = function (valid) {
                if (valid) {
                    $scope.error = "";
                    dataInputService.createMonitorPoint(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id,
                            $scope.name,
                            $scope.unit).then(function (result) {
                            newDataValues.selectedMonitorClass.monitor_points_for_all_locations =
                                newDataValues.selectedMonitorClass.monitor_points_for_all_locations || [];

                            //Add new monitor point to collection shown in dropdowns
                            newDataValues.selectedMonitorClass.monitor_points_for_all_locations.push(result);
                            newDataValues.monitorPoints[result.name] = result;

                            $scope.message = $scope.name + ' (' + $scope.unit + ') created';

                            //Message only needs to appear for a bit
                            $timeout(function () {
                                $scope.message = "";
                            }, 4000);

                            $scope.name = "";
                            $scope.unit = "";
                        }, function(result) {
                            $scope.error = result.error;
                        });
                }
            };

            $scope.name = "";
            $scope.unit = "";
            $scope.newDataValues = newDataValues;

        }]);