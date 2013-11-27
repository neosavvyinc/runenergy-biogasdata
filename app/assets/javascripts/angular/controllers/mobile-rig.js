RunEnergy.Dashboard.Controllers.controller('controllers.MobileRigController',
    ['$scope',
        function ($scope) {

            $scope.selectedLocation = null;
            $scope.locations = null;

            $scope.selectedMonitorClass = null;
            $scope.monitorClasses = null;

            var deregLocations = $scope.$watch('locations', function(val) {
                if (val && val.length) {
                    $scope.selectedLocation = val[0];
                    deregLocations();
                }
            });

            var deregMonitorClasses = $scope.$watch('monitorClasses', function(val) {
                if (val && val.length) {
                    $scope.selectedMonitorClass = val[0];
                    deregMonitorClasses();
                }
            });

        }]);