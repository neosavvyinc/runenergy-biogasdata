RunEnergy.Dashboard.Controllers.
    controller('controllers.DashboardController',
        ['$scope', '$rootScope', 'constants.Config', 'service.DashboardService', 'values.DashboardData', 'values.DashboardDateData', 'values.DashboardHeaderData', 'values.DashboardPageData',
            function ($scope, $rootScope, config, dashboardService, dashboardData, dashboardDateData, dashboardHeaderData, dashboardPageData) {

                //EVENT LISTENERS
                $scope.$on(config.EVENTS.APPLY_DATE_FILTERS, getAllFlareMonitorData);
                $scope.$on(config.EVENTS.CLEAR_FILTERS, getAllFlareMonitorData);

                //ACTION HANDLERS
                function dateRangeValid(startDate, startTime, endDate, endTime) {
                    if (startDate && endDate) {
                        var DATE_FORMAT = "DD/MM/YYYY";
                        var startMoment = moment(startDate, DATE_FORMAT);
                        var endMoment = moment(endDate, DATE_FORMAT);
                        if (startMoment.toDate().getTime() > endMoment.toDate().getTime()) {
                            return false;
                        } else if (startTime && endTime &&
                            startMoment.toDate().getTime() === endMoment.toDate().getTime()) {
                            var DATE_TIME_FORMAT = DATE_FORMAT + " HH:mm:ss";
                            startMoment = moment(startDate + " " + startTime, DATE_TIME_FORMAT);
                            endMoment = moment(endDate + " " + endTime, DATE_TIME_FORMAT);
                            return (startMoment.toDate().getTime() <= endMoment.toDate().getTime());
                        }
                    }
                    return true;
                }

                function getAllFlareMonitorData() {
                    if (dashboardHeaderData.flareSpecification) {
                        $scope.message = "";
                        if (dateRangeValid(dashboardDateData.startDate, dashboardDateData.startTime, dashboardDateData.endDate, dashboardDateData.endTime)) {
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
                        } else {
                            $scope.message = "Please specify a valid date range";
                        }
                    }
                }

                //WATCHERS
                var dereg = $scope.$watch('data.header', function (newValue) {
                    if (newValue && newValue.length) {
                        //Instantiates array of same size for filters
                        $scope.dashboardData.filters = newValue.map(function (item, index) {
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

                $scope.getColumnSort = function (column) {

                };

                //INITIALIZATION
                $scope.dashboardData = dashboardData;
                $scope.dashboardHeaderData = dashboardHeaderData;
                $scope.dashboardPageData = dashboardPageData;
                getAllFlareMonitorData();

            }]);