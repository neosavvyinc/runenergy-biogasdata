RunEnergy.Dashboard.Controllers.controller('controllers.PageController',
    ['$scope', '$rootScope', 'constants.Routes', 'values.DashboardPageData', 'values.DashboardHeaderData', 'values.DashboardDateData', 'values.DashboardData', 'service.DashboardService',
        function ($scope, $rootScope, routes, dashboardPageData, dashboardHeaderData, dashboardDateData, dashboardData, dashboardService) {

            //ACTION HANDLERS
            $scope.onNext = function () {
                dashboardPageData.page++;
            };

            $scope.onPrevious = function () {
                if (dashboardPageData.page > 0) {
                    dashboardPageData.page--;
                }
            };

            $scope.onExportCSV = function () {
                var filters = _.zipObject(
                    _.collect(dashboardData.flareMonitorData.header, 'attribute_name'),
                    _.collect(dashboardData.filters, 'expression')
                );
                dashboardService.getCSVExport(
                        dashboardHeaderData.flareSpecification.id,
                        dashboardDateData.startDate,
                        dashboardDateData.endDate,
                        dashboardDateData.startTime,
                        dashboardDateData.endTime,
                        filters).
                    then(function (result) {
                        //window.open("data:text/csv;charset=utf-8," + escape(result));
                        if (!result.success) {
                            throw "There has been an issue with the CSV exporting and filters.";
                        }
                    });
            };

            //GETTERS
            $scope.getExportCSVLink = function () {
                if (dashboardHeaderData.flareSpecification) {
                    return RunEnergy.Dashboard.Utils.RequestUrlUtils.withParams(
                        routes.DASHBOARD.CSV_EXPORT.READ, {
                            flareSpecificationId: dashboardHeaderData.flareSpecification.id
                        });
                }
                return "";
            };

            //INITIALIZATION
            $scope.dashboardPageData = dashboardPageData;


        }]);