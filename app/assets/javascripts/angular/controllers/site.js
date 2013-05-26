RunEnergy.Dashboard.Controllers.controller('controllers.SiteController',
    ['$scope', '$rootScope', 'service.DashboardService',
        function ($scope, $rootScope, dashboardService) {
            $scope.customers = dashboardService.getCustomers();
            $scope.locations = dashboardService.getEntitledLocations();
            $scope.flareSpecifications = dashboardService.getEntitledFlareSpecifications();
            $scope.selectedCustomer = null;
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

            var deregC = $scope.$watch('customers', function(newValue) {
                if (newValue && newValue.length) {
                    $scope.selectedCustomer = newValue[0];
                    deregC();
                }
            });
        }]);