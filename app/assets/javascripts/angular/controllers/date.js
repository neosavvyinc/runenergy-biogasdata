RunEnergy.Dashboard.Controllers.controller('controllers.DateController',
    ['$scope', '$rootScope', 'constants.Config', 'values.DashboardDateData', 'service.DashboardService', 'values.DashboardHeaderData',
        function ($scope, $rootScope, config, dashboardDateData, dashboardService, dashboardHeaderData) {

            //ACTION HANDLERS
            $scope.onApplyDateTimeFilters = function () {
                $rootScope.$broadcast(config.EVENTS.APPLY_DATE_FILTERS);
            };

            $scope.onClear = function () {
                dashboardDateData.startDate = null;
                dashboardDateData.endDate = null;
                dashboardDateData.startTime = "";
                dashboardDateData.endTime = "";
                $rootScope.$broadcast(config.EVENTS.CLEAR_FILTERS);
            };

            //INITIALIZATION
            $scope.dashboardDateData = dashboardDateData;
        }]);