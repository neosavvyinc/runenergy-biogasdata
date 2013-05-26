RunEnergy.Dashboard.Controllers.controller('controllers.SiteController',
    ['$scope', '$rootScope', 'service.DashboardService', 'values.DashboardHeaderData',
        function ($scope, $rootScope, dashboardService, dashboardHeaderData) {
            $scope.customers = dashboardService.getCustomers();
            $scope.locations = dashboardService.getEntitledLocations();
            $scope.flareSpecifications = dashboardService.getEntitledFlareSpecifications();
            $scope.dashboardHeaderData = dashboardHeaderData;

            var dereg = $scope.$watch('flareSpecifications', function (newValue) {
                if (newValue && newValue.length) {
                    dashboardHeaderData.flareSpecification = newValue[0];
                    dereg();
                }
            });

            var deregB = $scope.$watch('locations', function(newValue) {
                if (newValue && newValue.length) {
                    dashboardHeaderData.site = newValue[0];
                    deregB();
                }
            });

            var deregC = $scope.$watch('customers', function(newValue) {
                if (newValue && newValue.length) {
                    dashboardHeaderData.customer = newValue[0];
                    deregC();
                }
            });
        }]);