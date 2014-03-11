RunEnergy.Dashboard.Controllers.controller('controllers.DataInputController',
    ['$scope',
        'nsRailsService',
        'values.DashboardHeaderData',
        'values.NewDataValues',
        'services.DataInputService',
        'constants.Routes',
        'services.transformer.UniversalReadingResponseTransformer',
        function ($scope, nsRailsService, dashboardHeaderData, newDataValues, dataInputService, routes, readingResponse) {

            //Initialization
            $scope.currentFieldLog = {};
            $scope.currentReading = {};
            $scope.newDataValues = newDataValues;
            $scope.assetUniqueIdentifier = "";
            $scope.data = [];
            $scope.readingDate = null;
            $scope.createLocationsMonitorClass = false;
            $scope.newLocationsMonitorClass = {
                monitorPoints: []
            };

            //Watchers
            function _getReadings() {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
                    dataInputService.readings(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id
                        ).then(function (result) {
                            $scope.data = readingResponse(result);
                            if ($scope.data && $scope.data.length) {
                                $scope.header = $scope.data[0];
                            }
                        });
                }
            }

            function _getLocationsMonitorClass() {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
                    nsRailsService.request({
                        method: 'GET',
                        url: routes.DATA_INPUT.LOCATIONS_MONITOR_CLASS,
                        params: {':site_id': newDataValues.selectedSite.id, ':monitor_class_id': newDataValues.selectedMonitorClass.id}
                    }).then(function (result) {
                        newDataValues.selectedLocationsMonitorClass = result !== 'null' ? result : null;
                        return newDataValues.selectedLocationsMonitorClass;
                    }).then(function (result) {
                        $scope.createLocationsMonitorClass = ((!result || !result.monitor_points || !result.monitor_points.length) &&
                            newDataValues.selectedSite && newDataValues.selectedMonitorClass);
                    });
                }
            }

            var monitorPointNameToLimits;
            $scope.$watch('newDataValues.selectedLocationsMonitorClass', function (val) {
                if (val && val.monitor_limits && val.monitor_limits.length) {
                    monitorPointNameToLimits = {};
                    for (var i = 0; i < val.monitor_limits.length; i++) {
                        monitorPointNameToLimits[val.monitor_limits[i].monitor_point.name] = val.monitor_limits[i];
                    }
                } else {
                    monitorPointNameToLimits = null;
                }
            });
            $scope.$watch('newDataValues.selectedSite', function (val) {
                //Clear the models
                $scope.onReset();

                _getReadings();
                _getLocationsMonitorClass();

                //Make sure create is not available when there is no site
                if (!val) {
                    $scope.createLocationsMonitorClass = false;
                }
            });
            $scope.$watch('newDataValues.selectedMonitorClass', function (val) {
                //Clear the models
                $scope.onReset();

                _getReadings();
                _getLocationsMonitorClass();

                //Make sure create is not available when there is no site
                if (!val) {
                    $scope.createLocationsMonitorClass = false;
                }
            });

            //Getters
            $scope.getAssetAutoCompleteUrl = memoize(function (selectedSite, selectedMonitorClass) {
                var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS);
                if (selectedSite) {
                    builder.paramReplace(':site_id', selectedSite.id);
                }
                if (selectedMonitorClass) {
                    builder.paramReplace(':monitor_class_id', selectedMonitorClass.id);
                }
                return builder.build();
            });

            $scope.getMonitorLimitWarning = memoize(function (key, value) {
                if (monitorPointNameToLimits && key && value) {
                    if (parseFloat(value) > monitorPointNameToLimits[key].upper_limit) {
                        return "This value is above the upper limit of " + monitorPointNameToLimits[key].upper_limit;
                    } else if (parseFloat(value) < monitorPointNameToLimits[key].lower_limit) {
                        return "This value is below the lower limit of " + monitorPointNameToLimits[key].lower_limit;
                    }
                }
                return "";
            });

            $scope.getColumnLabel = memoize(function (key, monitorPoint) {
                if (key && monitorPoint && monitorPoint.unit) {
                    return key + " (" + monitorPoint.unit + ")";
                }
                return key;
            });

            $scope.getMonitorPointAdded = function (monitorPoint) {
                return $scope.newLocationsMonitorClass.monitorPoints.indexOf(monitorPoint) !== -1;
            };

            //Action Handlers
            function _remedyBlanks(reading, locationsMonitorClass) {
                if (reading && locationsMonitorClass && locationsMonitorClass.monitor_points) {
                    for (var i = 0; i < locationsMonitorClass.monitor_points.length; i++) {
                        if (_.isUndefined(reading[locationsMonitorClass.monitor_points[i].name])) {
                            reading[locationsMonitorClass.monitor_points[i].name] = "";
                        }
                    }
                }
                return reading;
            }

            $scope.onAdd = function () {
                $scope.error = "";
                if (newDataValues.selectedSite &&
                    newDataValues.selectedMonitorClass &&
                    $scope.assetUniqueIdentifier) {
                    if ($scope.readingDate) {
                        dataInputService.createReading(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id,
                            $scope.assetUniqueIdentifier,
                            $scope.currentFieldLog,
                            _remedyBlanks($scope.currentReading, newDataValues.selectedLocationsMonitorClass),
                            $scope.readingDate).then(_getReadings);
                    } else {
                        $scope.error = "Reading date is required";
                    }
                } else {
                    $scope.error = "Please type in or auto select an asset identifier";
                }
            };

            $scope.onReset = function () {
                $scope.currentFieldLog = {};
                $scope.currentReading = {};
            };

            $scope.onAssign = function () {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass
                    && $scope.newLocationsMonitorClass && $scope.newLocationsMonitorClass.monitorPoints
                    && $scope.newLocationsMonitorClass.monitorPoints.length) {
                    nsRailsService.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.LOCATIONS_MONITOR_CLASS,
                        params: {
                            ':site_id': newDataValues.selectedSite.id,
                            ':monitor_class_id': newDataValues.selectedMonitorClass.id
                        },
                        data: $scope.newLocationsMonitorClass
                    }).then(function (result) {
                        newDataValues.selectedLocationsMonitorClass = result;
                        $scope.createLocationsMonitorClass = false;
                        return result;
                    });
                }
            };

            $scope.onAddOrRemoveMonitorPointFromDefinition = function (monitorPoint) {
                if ($scope.newLocationsMonitorClass.monitorPoints.indexOf(monitorPoint) === -1) {
                    $scope.newLocationsMonitorClass.monitorPoints.push(monitorPoint);
                } else {
                    Neosavvy.Core.Utils.CollectionUtils.removeByProperty($scope.newLocationsMonitorClass.monitorPoints, monitorPoint, "id");
                }
            }
        }]);