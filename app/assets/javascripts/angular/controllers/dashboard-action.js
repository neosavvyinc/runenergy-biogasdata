RunEnergy.Dashboard.Controllers.controller('controllers.DashboardActionController',
    ['$scope',
        'values.NewDataValues',
        '$location',
        function ($scope,
                  newDataValues,
                  $location) {

            //Initialization
            $scope.landfillOperators = null;
            $scope.sites = null;
            $scope.sections = null;
            $scope.assets = null;
            $scope.monitorClasses = null;
            $scope.newDataValues = newDataValues;


            //Watchers
            function initValue(prop, locationProp, d, firstElement) {
                return function (val) {
                    if (val && val.length) {
                        if ($location.search()[locationProp]) {
                            var id = parseInt($location.search()[locationProp]);
                            Neosavvy.Core.Utils.MapUtils.applyTo($scope, prop,
                                Neosavvy.Core.Utils.CollectionUtils.itemByProperty(val, "id", id)
                            );
                        } else if (firstElement) {
                            Neosavvy.Core.Utils.MapUtils.applyTo($scope, prop, val[0]);
                        }
                        dereg[d]();
                    }
                };
            }

            function resetValuesBelow(propName, locationProp) {
                return function (newVal, oldVal) {
                    //Set url search parameter
                    if (newVal && newVal.id) {
                        $location.search(locationProp, newVal.id);
                    }

                    //Reset values
                    if (oldVal.id !== newVal.id) {
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
                    }
                };
            }

            var dereg = {};
            dereg.da = $scope.$watch('landfillOperators', initValue('newDataValues.selectedLandfillOperator', 'operator', 'da', true));
            dereg.db = $scope.$watch('sites', initValue('newDataValues.selectedSite', 'site', 'db'));
            dereg.dc = $scope.$watch('monitorClasses', initValue('newDataValues.selectedMonitorClass', 'monitor_class', 'dc'));
            dereg.dd = $scope.$watch('sections', initValue('newDataValues.selectedSection', 'section', 'dd'));
            dereg.de = $scope.$watch('assets', initValue('newDataValues.selectedAsset', 'asset', 'de'));

            //Action Handlers
            $scope.onFirstUserInteract = function () {
                $scope.$watch('newDataValues.selectedLandfillOperator', resetValuesBelow('newDataValues.selectedLandfillOperator', 'operator'));
                $scope.$watch('newDataValues.selectedSite', resetValuesBelow('newDataValues.selectedSite', 'site'));
                $scope.$watch('newDataValues.selectedMonitorClass', resetValuesBelow('newDataValues.selectedMonitorClass', 'monitor_class'));
                $scope.$watch('newDataValues.selectedSection', resetValuesBelow('newDataValues.selectedSection', 'section'));
                $scope.$watch('newDataValues.selectedAsset', resetValuesBelow('newDataValues.selectedAsset', 'asset'));
                $scope.onFirstUserInteract = function () {
                };
            };

        }]);