RunEnergy.Dashboard.Controllers.controller('controllers.DataAnalysisTable',
    ['$scope', 'values.NewDataValues', 'services.AnalysisService',
        function ($scope, newDataValues, analysisService) {

            //Getters
            var _getData = function () {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
                    analysisService.readings(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id,
                            $scope.startDateTime,
                            $scope.endDateTime
                        ).then(function (result) {
                            $scope.data = result ? _.map(result.readings, function(reading) {
                                reading.data['Date Time'] = reading.taken_at ? moment(reading.taken_at).format('DD/MM/YY, HH:mm:ss') : '';
                                return reading.data;
                            }) : null;
                        });
                }
            };

            $scope.getColumnLabel = memoize(function (key, monitorPoint) {
                if (key && monitorPoint && monitorPoint.unit) {
                    return key + " (" + monitorPoint.unit + ")";
                }
                return key;
            });

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


            //Initialization
            $scope.data = [];
            $scope.monitorPoints = [];
            $scope.monitorClass = null;
            $scope.page = 0;
            $scope.newDataValues = newDataValues;
            $scope.startDateTime = null;
            $scope.endDateTime = null;

        }]);