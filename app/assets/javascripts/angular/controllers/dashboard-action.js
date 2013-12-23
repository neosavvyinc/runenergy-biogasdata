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

            function resetValuesBelow(propName) {
                return function () {
                    switch (propName) {
                        case "newDataValues.selectedLandfillOperator":
                            newDataValues.selectedSite = null;
                        case "newDataValues.selectedSite":
                            newDataValues.selectedMonitorClass = null;
                        case "newDataValues.selectedMonitorClass":
                            newDataValues.selectedSection = null;
                        case "newDataValues.selectedSection":
                            newDataValues.selectedAsset = null;
                    }
                };
            }

            var dereg = {};
            dereg.da = $scope.$watch('landfillOperators', initValue('newDataValues.selectedLandfillOperator', 'da'));

            $scope.$watch('newDataValues.selectedLandfillOperator', resetValuesBelow('newDataValues.selectedLandfillOperator'));
            $scope.$watch('newDataValues.selectedSite', resetValuesBelow('newDataValues.selectedSite'));
            $scope.$watch('newDataValues.selectedMonitorClass', resetValuesBelow('newDataValues.selectedMonitorClass'));
            $scope.$watch('newDataValues.selectedSection', resetValuesBelow('newDataValues.selectedSection'));

        }]);