RunEnergy.Dashboard.Controllers.controller('controllers.DateController',
    ['$scope',
        '$rootScope',
        'constants.Config',
        'values.DashboardDateData', 
        function ($scope,
                  $rootScope,
                  config,
                  dashboardDateData) {

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