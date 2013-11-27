RunEnergy.Dashboard.Controllers.controller('controllers.MobileRigController',
    ['$scope', 'services.FieldApiService',
        function ($scope, fieldApi) {

            $scope.selectedLocation = null;
            $scope.locations = null;

            fieldApi.getSites().then(function(result) {
                $scope.locations = result;
                if ($scope.locations && $scope.locations.length) {
                    $scope.selectedLocation = $scope.locations[0];
                }
            });

            $scope.selectedMonitorClass = null;
            $scope.monitorClasses = null;

            fieldApi.getMonitorClasses().then(function (result) {
                $scope.monitorClasses = result;
                if ($scope.monitorClasses && $scope.monitorClasses.length) {
                    $scope.selectedMonitorClass = $scope.monitorClasses[0];
                }
            });
        }]);