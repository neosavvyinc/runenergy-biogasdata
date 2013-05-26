RunEnergy.Dashboard.Controllers.
    controller('controllers.DashboardController',
        ['$scope', '$rootScope', 'service.DashboardService', 'values.DashboardHeaderData', 'values.DashboardPageData',
            function ($scope, $rootScope, dashboardService, dashboardHeaderData, dashboardPageData) {

                //ACTION HANDLERS
                function getAllFlareMonitorData() {
                    if (dashboardHeaderData.flareSpecification) {
                        $scope.data = dashboardService.getAllFlareMonitorData(dashboardHeaderData.flareSpecification.id, null, null, dashboardPageData.page, dashboardPageData.page + 1);
                    }
                }

                //WATCHERS
                var dereg = $scope.$watch('data.header', function (newValue) {
                    if (newValue && newValue.length) {
                        //Instantiates array of same size for filters
                        $scope.filters = newValue.map(function (item, index) {
                            return {expression: "", index: index};
                        });
                        dereg();
                    }
                });

                $scope.$watch('dashboardHeaderData.flareSpecification', getAllFlareMonitorData);
                $scope.$watch('dashboardPageData.page', getAllFlareMonitorData);

                //INITIALIZATION
                $scope.filters = [];
                $scope.dashboardHeaderData = dashboardHeaderData;
                $scope.dashboardPageData = dashboardPageData;
                getAllFlareMonitorData();

            }]);