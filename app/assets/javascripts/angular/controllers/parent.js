RunEnergy.Dashboard.Controllers.controller('controllers.ParentController',
    ['$scope', '$rootScope', 'constants.Config', 'values.DashboardPageData',
        function ($scope, $rootScope, config, pageData) {
            //EVENT LISTENERS
            $scope.$on(config.EVENTS.DASHBOARD_LOADED, function() {
                $scope.loading = false;
                pageData.page = 0;
            });

            $scope.$on(config.EVENTS.DASHBOARD_LOADING, function() {
                $scope.loading = true;
            });
        }]);