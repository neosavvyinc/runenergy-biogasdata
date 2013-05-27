RunEnergy.Dashboard.Controllers.
    controller('controllers.DashboardController',
        ['$scope', '$rootScope', 'constants.Config', 'service.DashboardService', 'values.DashboardDateData', 'values.DashboardHeaderData', 'values.DashboardPageData',
            function ($scope, $rootScope, config, dashboardService, dashboardDateData, dashboardHeaderData, dashboardPageData) {

                //EVENT LISTENERS
                $scope.$on(config.EVENTS.APPLY_DATE_FILTERS, function () {
                    dashboardService.getAllFlareMonitorData(dashboardHeaderData.flareSpecification.id, dashboardDateData.startDate, dashboardDateData.endDate, dashboardDateData.startTime, dashboardDateData.endTime, 0, 1).then(function (result) {
                        $scope.data = result;
                    });
                });

                //ACTION HANDLERS
                function getAllFlareMonitorData() {
                    if (dashboardHeaderData.flareSpecification) {
                        dashboardService.getAllFlareMonitorData(dashboardHeaderData.flareSpecification.id, null, null, dashboardPageData.page, dashboardPageData.page + 1).
                            then(function (result) {
                                $scope.data = result;
                                $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADED);
                            });
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
                $scope.$watch('dashboardPageData.page', function (newValue, oldValue) {
                    if (newValue > oldValue) {
                        //Pre-loads the next page for the user
                        dashboardService.getAllFlareMonitorData(dashboardHeaderData.flareSpecification.id, dashboardDateData.startDate, dashboardDateData.endDate, dashboardDateData.startDate, dashboardDateData.endDate, dashboardDateData.startDate, dashboardDateData.endDate, dashboardPageData.page + 1, dashboardPageData.page + 2).
                            then(function (result) {
                                $scope.data.values = $scope.data.values.concat(result.values);
                            });
                    }
                });

                //INITIALIZATION
                $scope.filters = [];
                $scope.dashboardHeaderData = dashboardHeaderData;
                $scope.dashboardPageData = dashboardPageData;
                getAllFlareMonitorData();

            }]);