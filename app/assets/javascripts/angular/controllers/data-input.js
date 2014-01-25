RunEnergy.Dashboard.Controllers.controller('controllers.DataInputController',
    ['$scope', 'values.DashboardHeaderData', 'values.NewDataValues', 'services.DataInputService', 'constants.Routes',
        function ($scope, dashboardHeaderData, newDataValues, dataInputService, routes) {

            //Initialization
            $scope.currentFieldLog = {};
            $scope.currentReading = {};
            $scope.newDataValues = newDataValues;
            $scope.assetUniqueIdentifier = "";
            $scope.data = [];
            $scope.readingDate = null;

            //Watchers
            function _getReadings() {
                if (newDataValues.selectedSite && newDataValues.selectedMonitorClass) {
                    dataInputService.readings(
                            newDataValues.selectedSite.id,
                            newDataValues.selectedMonitorClass.id
                        ).then(function (result) {
                            $scope.data = _.map(result, 'data');
                        });
                }
            }

            var monitorPointNameToLimits;
            $scope.$watch('newDataValues.selectedSite', function (val) {
                if (val && val.monitor_limits && val.monitor_limits.length) {
                    monitorPointNameToLimits = {};
                    for (var i = 0; i < val.monitor_limits.length; i++) {
                        monitorPointNameToLimits[val.monitor_limits[i].monitor_point.name] = val.monitor_limits[i];
                    }
                } else {
                    monitorPointNameToLimits = null;
                }

                //Clear the models
                $scope.onReset();

                _getReadings();
            });
            $scope.$watch('newDataValues.selectedMonitorClass', function () {
                //Clear the models
                $scope.onReset();

                _getReadings();
            });

            //Getters
            $scope.getAssetAutoCompleteUrl = memoize(function(selectedSite, selectedMonitorClass) {
                var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.ASSETS);
                if (selectedSite) {
                    builder.paramReplace(':site_id', selectedSite.id);
                }
                if (selectedMonitorClass) {
                    builder.paramReplace(':monitor_class_id', selectedMonitorClass.id);
                }
                return builder.build();
            });

            $scope.getMonitorLimitWarning = memoize(function(key, value) {
                if (monitorPointNameToLimits && key && value) {
                    if (parseFloat(value) > monitorPointNameToLimits[key].upper_limit) {
                        return "This value is above the upper limit of " + monitorPointNameToLimits[key].upper_limit;
                    } else if (parseFloat(value) < monitorPointNameToLimits[key].lower_limit) {
                        return "This value is below the lower limit of " + monitorPointNameToLimits[key].lower_limit;
                    }
                }
                return "";
            });

            //Action Handlers
            $scope.onAdd = function () {
                if (newDataValues.selectedSite &&
                    newDataValues.selectedMonitorClass) {
                    $scope.error = "";
                    dataInputService.createReading(
                        newDataValues.selectedSite.id,
                        newDataValues.selectedMonitorClass.id,
                        $scope.assetUniqueIdentifier,
                        $scope.currentFieldLog,
                        $scope.currentReading,
                        $scope.readingDate).then(_getReadings);
                } else {
                    $scope.error = "Please fill in all fields for the reading.";
                }
            };

            $scope.onReset = function () {
                $scope.currentFieldLog = {};
                $scope.currentReading = {};
            };


            //Temp
            newDataValues.selectedSite = {id: 3};
            newDataValues.selectedMonitorClass = {id: 5};
            //_getReadings();

        }]);