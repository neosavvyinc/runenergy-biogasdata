RunEnergy.Dashboard.Controllers.controller('controllers.ParentController',
    ['$scope', '$rootScope', 'constants.Config',
        function ($scope, $rootScope, config) {
            //EVENT LISTENERS
            $scope.$on(config.EVENTS.DASHBOARD_LOADED, function() {
                $scope.loading = false;
            });

            //INITIALIZATION
            $scope.loading = true;
        }]);