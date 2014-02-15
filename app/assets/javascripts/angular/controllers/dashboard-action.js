RunEnergy.Dashboard.Controllers.controller('controllers.DashboardActionController',
    ['$scope',
        'values.NewDataValues',
        '$location',
        '$filter',
        'values.Notifications',
        'nsRailsService',
        'constants.Routes',
        function ($scope, newDataValues, $location, $filter, notifications, nsRailsService, routes) {
            var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
            var itemByProperty = Neosavvy.Core.Utils.CollectionUtils.itemByProperty;

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
            function _initValue(prop, locationProp, d, firstElement) {
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

            function _resetValuesBelow(propName, locationProp) {
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
                                newDataValues.selectedLocationsMonitorClass = null;
                            case "newDataValues.selectedMonitorClass":
                                newDataValues.selectedSection = null;
                            case "newDataValues.selectedSection":
                                newDataValues.selectedAsset = null;
                        }
                    }
                };
            }

            function _chooseAccordingValues() {
                if (hpGet(newDataValues, 'selectedAsset.id')) {
                    newDataValues.selectedSite = itemByProperty($scope.sites, "id", newDataValues.selectedAsset.location_id);
                    newDataValues.selectedMonitorClass = itemByProperty($scope.monitorClasses, "id", newDataValues.selectedAsset.monitor_class_id);
                    newDataValues.selectedSection = itemByProperty($scope.sections, "id", newDataValues.selectedAsset.section_id);
                }
            }

            var dereg = {};
            dereg.da = $scope.$watch('landfillOperators', _initValue('newDataValues.selectedLandfillOperator', 'operator', 'da', true));
            dereg.db = $scope.$watch('sites', _initValue('newDataValues.selectedSite', 'site', 'db'));
            dereg.dc = $scope.$watch('monitorClasses', _initValue('newDataValues.selectedMonitorClass', 'monitor_class', 'dc'));
            dereg.dd = $scope.$watch('sections', _initValue('newDataValues.selectedSection', 'section', 'dd'));
            dereg.de = $scope.$watch('assets', _initValue('newDataValues.selectedAsset', 'asset', 'de'));

            var nsCollectionFilterProperties = $filter('nsCollectionFilterProperties');
            var nsCollectionFilterProperty = $filter('nsCollectionFilterProperty');
            var _filterAssets = memoize(function (assets, newDataValues) {
                var nAssets = assets;
                if (newDataValues.selectedSite && newDataValues.selectedSite.id) {
                    nAssets = nsCollectionFilterProperty(nAssets, 'location_id', newDataValues.selectedSite.id);
                }
                if (newDataValues.selectedMonitorClass && newDataValues.selectedMonitorClass.id) {
                    nAssets = nsCollectionFilterProperty(nAssets, 'monitor_class_id', newDataValues.selectedMonitorClass.id);
                }
                if (newDataValues.selectedSection && newDataValues.selectedSection.id) {
                    nAssets = nsCollectionFilterProperty(nAssets, 'section_id', newDataValues.selectedSection.id);
                }
                return nAssets;
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
            $scope.$watch('newDataValues.selectedAsset', _chooseAccordingValues);

            //Action Handlers
            $scope.onFirstUserInteract = function () {
                $scope.$watch('newDataValues.selectedLandfillOperator', _resetValuesBelow('newDataValues.selectedLandfillOperator', 'operator'));
                $scope.$watch('newDataValues.selectedSite', _resetValuesBelow('newDataValues.selectedSite', 'site'));
                $scope.$watch('newDataValues.selectedMonitorClass', _resetValuesBelow('newDataValues.selectedMonitorClass', 'monitor_class'));
                $scope.$watch('newDataValues.selectedSection', _resetValuesBelow('newDataValues.selectedSection', 'section'));
                $scope.onFirstUserInteract = function () {
                };
            };

            $scope.onReset = function () {
                newDataValues.selectedSection = null;
                newDataValues.selectedAsset = null;
            };

            $scope.onSaveEdit = function () {
                notifications.editSavedTrigger++;
            };

        }]);