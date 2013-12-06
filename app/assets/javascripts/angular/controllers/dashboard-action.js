RunEnergy.Dashboard.Controllers.controller('controllers.DashboardActionController',
    ['$scope', 'values.NewDataValues',
        function ($scope, newDataValues) {

            $scope.landfillOperators = null;
            $scope.sites = null;
            $scope.sections = null;
            $scope.assets = null;
            $scope.monitorClasses = null;
            $scope.newDataValues = newDataValues;

            //Watchers
            function initValue(prop, d) {
                return function (val) {
                    if (val && val.length) {
                        Neosavvy.Core.Utils.MapUtils.applyTo($scope, prop, val[0]);
                        dereg[d]();
                    }
                };
            }

            var dereg = {};
            dereg.da = $scope.$watch('landfillOperators', initValue('newDataValues.selectedLandfillOperator', 'da'));
            dereg.db = $scope.$watch('monitorClasses', initValue('newDataValues.selectedMonitorClass', 'db'));

        }]);