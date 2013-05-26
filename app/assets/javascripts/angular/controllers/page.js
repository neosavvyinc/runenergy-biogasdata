RunEnergy.Dashboard.Controllers.controller('controllers.PageController',
    ['$scope', '$rootScope', 'constants.Routes', 'values.DashboardPageData', 'values.DashboardHeaderData',
        function ($scope, $rootScope, routes, dashboardPageData, dashboardHeaderData) {

            //ACTION HANDLERS
            $scope.onNext = function () {
                dashboardPageData.page++;
            };

            $scope.onPrevious = function () {
                if (dashboardPageData > 0) {
                    dashboardPageData.page--;
                }
            };

            //GETTERS
            $scope.getExportCSVLink = function () {
                if (dashboardHeaderData.flareSpecification) {
                    return RunEnergy.Dashboard.Utils.RequestUrlUtils.withParams(
                        routes.DASHBOARD.CSV_EXPORT.CREATE, {
                            flareSpecificationId: dashboardHeaderData.flareSpecification.id
                        });
                }
                return "";
            };

            //INITIALIZATION
            $scope.dashboardPageData = dashboardPageData;


        }]);