RunEnergy.Dashboard.Controllers.controller('controllers.DataAnalysisTable',
    ['$scope',
        '$filter',
        '$parse',
        'nsRailsService',
        'values.NewDataValues',
        'services.AnalysisService',
        'constants.Routes',
        '$controller',
        'values.Notifications',
        'service.transformer.UniversalStripAngularKeysRequest',
        'services.transformer.UniversalReadingResponseTransformer',
        '$location',
        function ($scope, $filter, $parse, nsRailsService, newDataValues, analysisService, routes, $controller, notifications, stripAngularKeysRequest, readingResponse, $location) {
            var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;

            //Helpers
            $controller('controllers.helpers.DataTable', {$scope: $scope});

            var underEdit = null;
            $scope.rowUnderEdit = null;

            //Getters
            var _epochDateFor = function (dateTime) {
                if (dateTime) {
                    return parseInt(dateTime.getTime() / 1000)
                }
                return dateTime;
            };

            var _getData = _.debounce(function () {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
                    $scope.loading = true;
                    nsRailsService.request({
                        method: 'GET',
                        url: routes.ANALYSIS.READINGS,
                        params: {
                            ':site_id': newDataValues.selectedSite.id,
                            ':monitor_class_id': newDataValues.selectedMonitorClass.id
                        },
                        optional: {
                            'section_id': hpGet(newDataValues, 'selectedSection.id'),
                            'asset_id': hpGet(newDataValues, 'selectedAsset.id'),
                            'start_date_time': _epochDateFor($scope.startDateTime),
                            'end_date_time': _epochDateFor($scope.endDateTime),
                            'offset': $scope.page
                        }
                    }).then(function (result) {
                        $scope.loading = false;
                        $scope.allData = readingResponse(hpGet(result, 'readings'), true);
                        if ($scope.allData && $scope.allData.length) {
                            $scope.header = $scope.allData[0];
                            $scope.data = $scope.allData.concat();
                        }
                    });
                }
            }, 20);

            $scope.getEdit = function (row) {
                return (underEdit === row.$$hashKey);
            };

            //Watchers
            $scope.$watch('allData', function (val) {
                if (val && val.length && newDataValues.selectedMonitorClass) {
                    $scope.filters = _.map(
                        $filter('reCollectionOrderedPairs')
                            (val[0], newDataValues.selectedMonitorClass.monitor_point_ordering), function (item) {
                            return {key: item[0], expression: ""};
                        });
                }
            });


            $scope.$watch('filters', _.debounce(function (val) {
                if (val && val.length) {
                    $scope.$apply(function () {
                        var keysToExpressions = (function _keysToExpressions(ar) {
                            var hash = {};
                            for (var i = 0; i < ar.length; i++) {
                                if (ar[i].expression && /\d/g.test(ar[i].expression)) {
                                    hash[ar[i].key] = ar[i].expression.replace(/=/g, '==');
                                }
                            }
                            return hash;
                        })(val);

                        //Filter data using parse
                        $scope.data = _.filter($scope.allData, function (row) {
                            try {
                                for (var key in keysToExpressions) {
                                    if (!$parse(String(row[key]) + keysToExpressions[key])()) {
                                        return false
                                    }
                                }
                                return true;
                            } catch (e) {
                                return false;
                            }
                        });
                    });
                }
            }, 300), true);

            $scope.notifications = notifications;
            $scope.$watch('notifications.editSavedTrigger', function () {
                if ($scope.rowUnderEdit && $scope.rowUnderEdit.id) {
                    if (/\d\d\/\d\d\/\d\d, \d\d:\d\d:\d\d/g.test($scope.rowUnderEdit['Date Time']) &&
                        moment($scope.rowUnderEdit['Date Time']).isValid()) {
                        nsRailsService.request({
                            method: 'POST',
                            url: routes.ANALYSIS.UPDATE_READING,
                            params: {
                                ':id': $scope.rowUnderEdit.id
                            },
                            ignoreDataKeys: true,
                            data: $scope.rowUnderEdit,
                            transformRequest: stripAngularKeysRequest
                        }).then(function (result) {
                            $scope.rowToReplace = Neosavvy.Core.Utils.CollectionUtils.updateByProperty($scope.data, angular.copy($scope.rowUnderEdit), "id");
                            underEdit = null;
                        });
                        $scope.error = "";
                    } else {
                        $scope.error = 'Please enter a valid date time of the format: DD/MM/YY, HH:MM:SS';
                    }
                }
            });

            $scope.$watch('newDataValues.selectedSite', _getData);
            $scope.$watch('newDataValues.selectedMonitorClass', _getData);
            $scope.$watch('newDataValues.selectedSection', _getData);
            $scope.$watch('newDataValues.selectedAsset', _getData);
            $scope.$watch('startDateTime.getTime()', _getData);
            $scope.$watch('endDateTime.getTime()', _getData);
            $scope.$watch('page', _getData);

            //Action Handlers
            $scope.onPrev = function () {
                $scope.page = Math.max(1, $scope.page - 1);
            };

            $scope.onNext = function () {
                $scope.page += 1;
            };

            $scope.onEditRow = function (row) {
                if (hpGet(newDataValues, 'currentUser.can_edit')) {
                    var hashKey = hpGet(row, '$$hashKey');
                    if (underEdit !== hashKey) {
                        $scope.rowUnderEdit = angular.copy(row);
                        underEdit = hashKey;
                    }
                }
            };

            $scope.onPlotMonitorPoint = function (monitorPoint) {
                if (newDataValues.enable.plotMonitorPoint) {
                    if (monitorPoint && monitorPoint.id) {
                        window.location.href = new Neosavvy.Core.Builders.RequestUrlBuilder('/visualizations/monitor_point/:monitor_point_id#').
                            addParam($location.search()).
                            paramReplace(':monitor_point_id', monitorPoint.id).
                            build();
                    } else {
                        throw "You cannot plot a monitor point without passing in a valid monitor point.";
                    }
                }
            };

            //Initialization
            $scope.data = [];
            $scope.monitorPoints = [];
            $scope.monitorClass = null;
            $scope.page = 1;
            $scope.newDataValues = newDataValues;
            $scope.startDateTime = null;
            $scope.endDateTime = null;

        }]);