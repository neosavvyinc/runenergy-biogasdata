RunEnergy.Dashboard.Controllers.
    controller('controllers.DashboardController',
        ['$scope', '$rootScope', 'constants.Config', 'service.DashboardService', 'values.DashboardDateData', 'values.DashboardHeaderData', 'values.DashboardPageData',
            function ($scope, $rootScope, config, dashboardService, dashboardDateData, dashboardHeaderData, dashboardPageData) {

                //EVENT LISTENERS
                $scope.$on(config.EVENTS.APPLY_DATE_FILTERS, getAllFlareMonitorData);
                $scope.$on(config.EVENTS.CLEAR_FILTERS, getAllFlareMonitorData);

                //ACTION HANDLERS
                function getAllFlareMonitorData() {
                    if (dashboardHeaderData.flareSpecification) {
                        $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADING);
                        dashboardService.getAllFlareMonitorData(dashboardHeaderData.flareSpecification.id, dashboardDateData.startDate, dashboardDateData.endDate, dashboardDateData.startTime, dashboardDateData.endTime, 0, 1).
                            then(
                            function (result) {
                                $scope.data = result;
                                $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADED);
                            },
                            function (result) {
                                $scope.message = "There is no monitor data for this flare deployment";
                                $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADED);
                            }
                        );
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
                        if ($scope.data) {
                            dashboardService.getAllFlareMonitorData(dashboardHeaderData.flareSpecification.id, dashboardDateData.startDate, dashboardDateData.endDate, dashboardDateData.startTime, dashboardDateData.endTime, dashboardPageData.page + 1, dashboardPageData.page + 2).
                                then(function (result) {
                                    $scope.data.values = $scope.data.values.concat(result.values);
                                });
                        }
                    }
                });

                //GETTERS
                $scope.getSignificantDigits = function (index) {
                    var significantDigits = $scope.data.header[index].significant_digits;
                    return RunEnergy.Dashboard.Utils.NumberUtils.isNumber(significantDigits) ? significantDigits : 2;
                };

                //INITIALIZATION
                $scope.filters = [];
                $scope.dashboardHeaderData = dashboardHeaderData;
                $scope.dashboardPageData = dashboardPageData;
                getAllFlareMonitorData();

            }]);