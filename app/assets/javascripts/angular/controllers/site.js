RunEnergy.Dashboard.Controllers.controller('controllers.SiteController',
    ['$scope', '$rootScope', 'service.DashboardService',
        function ($scope, $rootScope, dashboardService) {
            $scope.flareSpecifications = dashboardService.getEntitledFlareSpecifications();
            $scope.selectedFlareSpecification = null;

            var dereg = $scope.$watch('flareSpecifications', function (newValue) {
                if (newValue && newValue.length) {
                    $scope.selectedFlareSpecification = newValue[0];
                    dereg();
                }
            })
        }]);