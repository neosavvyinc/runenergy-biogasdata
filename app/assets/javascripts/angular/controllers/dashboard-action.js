RunEnergy.Dashboard.Controllers.controller('controllers.DashboardActionController',
    ['$scope', 'values.NewDataValues',
        function ($scope, newDataValues) {

            $scope.landfillOperators = null;
            $scope.sites = null;
            $scope.monitorClasses = null;
            $scope.sections = null;
            $scope.newDataValues = newDataValues;

        }]);