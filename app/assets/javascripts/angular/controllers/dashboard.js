RunEnergy.Dashboard.Controllers.
    controller('controllers.DashboardController',
        ['$scope', '$rootScope', 'service.DashboardService',
            function ($scope, $rootScope, dashboardService) {

                //INITIALIZATION
                $scope.data = dashboardService.getAllFlareMonitorData();

            }]);