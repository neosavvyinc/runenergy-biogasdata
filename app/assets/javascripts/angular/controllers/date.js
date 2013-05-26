RunEnergy.Dashboard.Controllers.controller('controllers.DateController',
    ['$scope', '$rootScope', 'values.DashboardDateData',
        function ($scope, $rootScope, dashboardDateData) {
            $scope.dashboardDateData = dashboardDateData;
        }]);