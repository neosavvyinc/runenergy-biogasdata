RunEnergy.Dashboard.Controllers.controller('controllers.DashboardActionController',
    ['$scope',
        'values.NewDataValues',
        '$location',
        '$filter',
        function ($scope,
                  newDataValues,
                  $location,
                  $filter) {

            //Initialization, Perm Values
            $scope.landfillOperators = null;
            $scope.sites = null;
            $scope.sections = null;
            $scope.assets = null;
            $scope.monitorClasses = null;

            //Transient Values
            $scope.availableSites = null;
            $scope.availableSections = null;
            $scope.availableAssets = null;
            $scope.availableMonitorClasses = null;

            //Global Values
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
                    if (oldVal && newVal && oldVal.id !== newVal.id) {
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

            var nsCollectionFilterProperties = $filter('nsCollectionFilterProperties');
            var nsCollectionFilterProperty = $filter('nsCollectionFilterProperty');
            var _filterAssets = memoize(function (assets, newDataValues) {
                var nAssets;
                if (newDataValues.selectedSite && newDataValues.selectedSite.id) {
                    nAssets = nsCollectionFilterProperty(assets, 'location_id', newDataValues.selectedSite.id);
                }
                if (newDataValues.selectedMonitorClass && newDataValues.selectedMonitorClass.id) {
                    nAssets = nsCollectionFilterProperty(assets, 'monitor_class_id', newDataValues.selectedMonitorClass.id);
                }
                if (newDataValues.selectedSection && newDataValues.selectedSection.id) {
                    nAssets = nsCollectionFilterProperty(assets, 'section_id', newDataValues.selectedSection.id);
                }
                return nAssets || assets;
            });
            var _watchAssets = function () {
                $scope.availableAssets = _filterAssets($scope.assets, newDataValues);
            };

            $scope.$watch('newDataValues.selectedLandfillOperator', function (val) {
                if (val && val.location_ids && val.location_ids.length && $scope.sites && $scope.sites.length) {
                    $scope.availableSites = nsCollectionFilterProperties($scope.sites, 'id', val.location_ids);
                }
            });
            $scope.$watch('newDataValues.selectedSite', function (val) {
                if (val && val.monitor_class_ids && val.monitor_class_ids.length && $scope.monitorClasses && $scope.monitorClasses.length) {
                    $scope.availableMonitorClasses = nsCollectionFilterProperties($scope.monitorClasses, 'id', val.monitor_class_ids);
                    $scope.availableSections = nsCollectionFilterProperties($scope.sections, 'id', val.section_ids);
                }
                _watchAssets();
            });
            $scope.$watch('newDataValues.selectedMonitorClass', _watchAssets);
            $scope.$watch('newDataValues.selectedSection', _watchAssets);

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