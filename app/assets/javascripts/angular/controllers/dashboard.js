RunEnergy.Dashboard.Controllers.
    controller('controllers.DashboardController',
        ['$scope', '$rootScope', 'service.DashboardService',
            function ($scope, $rootScope, dashboardService) {

                //WATCHERS
                var dereg = $scope.$watch('data.header', function(newValue) {
                    if (newValue && newValue.length) {
                        //Instantiates array of same size for filters
                        $scope.filters = newValue.map(function(item, index) {
                            return {expression: "", index: index};
                        });
                        dereg();
                    }
                });

                //INITIALIZATION
                $scope.data = dashboardService.getAllFlareMonitorData();
                $scope.filters = [];

            }]);