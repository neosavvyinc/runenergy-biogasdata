RunEnergy.Dashboard.Controllers.controller('controllers.SiteController',
    ['$scope', '$rootScope', 'service.DashboardService',
        function ($scope, $rootScope, dashboardService) {
            $scope.locations = dashboardService.getEntitledLocations();
            $scope.flareSpecifications = dashboardService.getEntitledFlareSpecifications();
            $scope.selectedLocation = null;
            $scope.selectedFlareSpecification = null;

            var dereg = $scope.$watch('flareSpecifications', function (newValue) {
                if (newValue && newValue.length) {
                    $scope.selectedFlareSpecification = newValue[0];
                    dereg();
                }
            });

            var deregB = $scope.$watch('locations', function(newValue) {
                if (newValue && newValue.length) {
                    $scope.selectedLocation = newValue[0];
                    deregB();
                }
            });
        }]);