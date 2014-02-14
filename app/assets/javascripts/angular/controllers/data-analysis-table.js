RunEnergy.Dashboard.Controllers.controller('controllers.DataAnalysisTable',
    ['$scope',
        'nsRailsService',
        'values.NewDataValues',
        'services.AnalysisService',
        'constants.Routes',
        '$controller',
        'values.Notifications',
        'service.transformer.UniversalStripAngularKeysRequest',
        function ($scope,
                  nsRailsService,
                  newDataValues,
                  analysisService,
                  routes,
                  $controller,
                  notifications,
                  stripAngularKeysRequest) {
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
                        $scope.data = result ? _.map(result.readings, function (reading) {
                            reading.data['id'] = reading.id;
                            reading.data['Date Time'] = reading.taken_at ? moment(reading.taken_at).format('DD/MM/YY, HH:mm:ss') : '';
                            return reading.data;
                        }) : null;
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
                $scope.page = Math.min($scope.page + 1, parseInt($scope.data.length / 500) - 1);
            };

            $scope.onEditRow = function (row) {
                if (newDataValues.currentUser.edit_permission) {
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