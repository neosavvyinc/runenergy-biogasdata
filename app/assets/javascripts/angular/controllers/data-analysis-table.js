RunEnergy.Dashboard.Controllers.controller('controllers.DataAnalysisTable',
    ['$scope',
        'nsRailsService',
        'values.NewDataValues',
        'services.AnalysisService',
        'constants.Routes',
        '$controller',
        'values.Notifications',
        'service.transformer.UniversalStripAngularKeysRequest',
        'services.transformer.UniversalReadingResponseTransformer',
        function ($scope, nsRailsService, newDataValues, analysisService, routes, $controller, notifications, stripAngularKeysRequest, readingResponse) {
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

            var _getData = function () {
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
                            'asset_id': hpGet(newDataValues, 'selectedAsset.id'),
                            'start_date_time': _epochDateFor($scope.startDateTime),
                            'end_date_time': _epochDateFor($scope.endDateTime)
                        }
                    }).then(function (result) {
                        $scope.loading = false;
                        $scope.data = readingResponse(hpGet(result, 'readings'), true);
                    });
                }
            };

            $scope.getEdit = function (row) {
                return (underEdit === row.$$hashKey);
            };

            //Watchers
            $scope.$watch('data', function (val) {
                if (val && val.length) {
                    $scope.filters = angular.copy(val[0]);
                    for (var key in $scope.filters) {
                        $scope.filters[key] = "";
                    }
                }
            });

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
            $scope.$watch('newDataValues.selectedAsset', _getData);
            $scope.$watch('startDateTime.getTime()', _getData);
            $scope.$watch('endDateTime.getTime()', _getData);

            //Action Handlers
            $scope.onPrev = function () {
                $scope.page = Math.max(0, $scope.page - 1);
            };

            $scope.onNext = function () {
                $scope.page = Math.min($scope.page + 1, parseInt($scope.data.length / 500) - (($scope.data.length % 500) ? 0 : 1));
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

            //Initialization
            $scope.data = [];
            $scope.monitorPoints = [];
            $scope.monitorClass = null;
            $scope.page = 0;
            $scope.newDataValues = newDataValues;
            $scope.startDateTime = null;
            $scope.endDateTime = null;

        }]);