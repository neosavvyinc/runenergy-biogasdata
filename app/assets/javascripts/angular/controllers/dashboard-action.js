RunEnergy.Dashboard.Controllers.controller('controllers.DashboardActionController',
    ['$scope', 'values.NewDataValues',
        function ($scope, newDataValues) {

            $scope.landfillOperators = null;
            $scope.sites = null;
            $scope.monitorClasses = null;
            $scope.sections = null;
            $scope.newDataValues = newDataValues;

            //Watchers
            function initValue(prop, dereg) {
                return function (val) {
                    if (val && val.length) {
                        Neosavvy.Core.Utils.MapUtils.applyTo($scope, prop, val[0]);
                        dereg[dereg]();
                    }
                };
            }

            var dereg = {};
            dereg.da = $scope.$watch('landfillOperators', initValue('newDataValues.selectedLandfillOperator', 'da'));
            dereg.db = $scope.$watch('sites', initValue('newDataValues.selectedSite', 'db'));
            dereg.dc = $scope.$watch('monitorClasses', initValue('newDataValues.selectedMonitorClass', 'dc'));
            dereg.dd = $scope.$watch('sections', initValue('newDataValues.selectedSection', 'dd'));

        }]);