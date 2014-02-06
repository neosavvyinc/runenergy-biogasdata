RunEnergy.Dashboard.Controllers.controller('controllers.DataAnalysisTable',
    ['$scope', 'nsRailsService', 'values.NewDataValues', 'services.AnalysisService', 'constants.Routes', '$controller',
        function ($scope, nsRailsService, newDataValues, analysisService, routes, $controller) {
            var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;

            //Helpers
            $controller('controllers.helpers.DataTable', {$scope: $scope});

            //Getters
            var _epochDateFor = function (dateTime) {
                if (dateTime) {
                    return parseInt(dateTime.getTime() / 1000)
                }
                return dateTime;
            };

            var _getData = function () {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
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
                        $scope.data = result ? _.map(result.readings, function(reading) {
                            reading.data['Date Time'] = reading.taken_at ? moment(reading.taken_at).format('DD/MM/YY, HH:mm:ss') : '';
                            return reading.data;
                        }) : null;
                    });
                }
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

            $scope.$watch('newDataValues.selectedSite', _getData);
            $scope.$watch('newDataValues.selectedMonitorClass', _getData);
            $scope.$watch('newDataValues.selectedAsset', _getData);
            $scope.$watch('startDateTime.getTime()', _getData);
            $scope.$watch('endDateTime.getTime()', _getData);


            //Initialization
            $scope.data = [];
            $scope.monitorPoints = [];
            $scope.monitorClass = null;
            $scope.page = 0;
            $scope.newDataValues = newDataValues;
            $scope.startDateTime = null;
            $scope.endDateTime = null;

        }]);