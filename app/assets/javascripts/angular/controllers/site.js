RunEnergy.Dashboard.Controllers.controller('controllers.SiteController',
    ['$scope', '$rootScope', 'service.DashboardService', 'values.DashboardHeaderData',
        function ($scope, $rootScope, dashboardService, dashboardHeaderData) {
            $scope.customers = dashboardService.getCustomers();
            $scope.locations = dashboardService.getEntitledLocations();
            $scope.dashboardHeaderData = dashboardHeaderData;

            //WATCHERS
            var deregC = $scope.$watch('customers', function (newValue) {
                if (newValue && newValue.length) {
                    dashboardHeaderData.customer = newValue[0];
                    deregC();
                }
            });

            $scope.$watch('locations', function (newValue) {
                if (newValue && newValue.length) {
                    dashboardHeaderData.site = newValue[0];
                }
            });

            $scope.$watch('dashboardHeaderData.customer', function (newValue) {
                if (newValue) {
                    $scope.locations = dashboardService.getEntitledLocations(newValue.id);
                }
            });

            $scope.$watch('dashboardHeaderData.site', function (newValue) {
                if (newValue && newValue.flare_specifications && newValue.flare_specifications.length) {
                    dashboardHeaderData.flareSpecification = newValue.flare_specifications[0];
                }
            });
        }]);