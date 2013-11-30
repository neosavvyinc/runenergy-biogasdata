RunEnergy.Dashboard.Controllers.controller('controllers.MobileRigController',
    ['$scope', 'services.FieldApiService',
        function ($scope, fieldApi) {

            $scope.deviceUid = null;

            $scope.currentFieldLog = {};
            $scope.currentReading = {};

            $scope.selectedLocation = null;
            $scope.locations = null;

            function _getReadings() {
                if ($scope.selectedLocation && $scope.selectedMonitorClass) {
                    fieldApi.getReadings($scope.selectedLocation.id, $scope.selectedMonitorClass.id).then(function (result) {
                        $scope.readings = result;
                    });
                }
            }

            fieldApi.getSites().then(function (result) {
                $scope.locations = result;
                if ($scope.locations && $scope.locations.length) {
                    $scope.selectedLocation = $scope.locations[0];
                }
            }).then(_getReadings);

            $scope.selectedMonitorClass = null;
            $scope.monitorClasses = null;

            fieldApi.getMonitorClasses().then(function (result) {
                $scope.monitorClasses = result;
                if ($scope.monitorClasses && $scope.monitorClasses.length) {
                    $scope.selectedMonitorClass = $scope.monitorClasses[0];
                }
            }).then(_getReadings);

            $scope.readings = null;

            $scope.onSend = function () {
                if ($scope.selectedLocation &&
                    $scope.selectedMonitorClass &&
                    _.keys($scope.currentFieldLog).length &&
                    _.keys($scope.currentReading).length) {
                    fieldApi.createReading($scope.selectedLocation.id,
                        $scope.selectedMonitorClass.id,
                        $scope.currentFieldLog,
                        $scope.currentReading).then(_getReadings);
                }
            };

            $scope.onSync = function() {
                if ($scope.deviceUid) {
                    fieldApi.sync($scope.deviceUid).then(function(result) {

                    });
                }
            };


        }]);