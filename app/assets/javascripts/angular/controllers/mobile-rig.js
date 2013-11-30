RunEnergy.Dashboard.Controllers.controller('controllers.MobileRigController',
    ['$scope', 'services.FieldApiService',
        function ($scope, fieldApi) {

            $scope.deviceUid = "uid400";

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
            });

            $scope.selectedMonitorClass = null;
            $scope.monitorClasses = null;

            fieldApi.getMonitorClasses().then(function (result) {
                $scope.monitorClasses = result;
            });

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

            $scope.showInterface = false;
            $scope.users = null;
            $scope.onSync = function () {
                if ($scope.deviceUid) {
                    $scope.showInterface = false;
                    fieldApi.sync($scope.deviceUid).then(
                        function (result) {
                            $scope.users = result;
                            $scope.showInterface = true;
                            $scope.error = null;
                            if ($scope.users && $scope.users.length) {
                                $scope.selectedUser = $scope.users[0];
                            }
                        },
                        function (result) {
                            $scope.error = "UID not found, check your spelling.";
                        });
                }
            };

            $scope.$watch('selectedUser', _getReadings);
            $scope.$watch('selectedLocation', _getReadings);
            $scope.$watch('selectedMonitorClass', _getReadings);


        }]);