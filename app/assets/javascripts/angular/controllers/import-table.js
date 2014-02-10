RunEnergy.Dashboard.Controllers.controller('controllers.ImportTable',
    ['$scope',
        'values.NewDataValues',
        'services.AnalysisService',
        function ($scope,
                  newDataValues,
                  analysisService) {

            if (!$scope.readingMods) {
                throw "You must define the readingMods on the scope for the import table.";
            }

            $scope.newDataValues = newDataValues;

            //Watchers
            $scope.$watch('newDataValues.selectedAsset', function(val) {
                if (val && val.id) {
                    analysisService.monitorPoints(val.id).then(function(result) {
                        $scope.monitorPoints = result.monitor_points;
                    });
                }
            });

            //Action Handlers
            $scope.onRemoveRow = function (index) {
                var indexOf = $scope.readingMods.deletedRowIndices.indexOf(index);
                if (indexOf === -1) {
                    $scope.readingMods.deletedRowIndices.push(index);
                } else {
                    $scope.readingMods.deletedRowIndices.splice(indexOf, 1);
                }
            };

            $scope.onRemoveColumn = function (name) {
                if ($scope.readingMods.deletedColumns[name]) {
                    delete $scope.readingMods.deletedColumns[name];
                } else {
                    $scope.readingMods.deletedColumns[name] = true;
                    delete $scope.readingMods.columnToMonitorPointMappings[name];
                }
            };

            //Getters
            $scope.getRowVariation = function (index, optionA, optionB) {
                return ($scope.readingMods.deletedRowIndices.indexOf(index) === -1 ? optionA : optionB);
            };

            $scope.getColumnVariation = function (key, optionA, optionB) {
                return (!$scope.readingMods.deletedColumns[key] ? optionA : optionB);
            };

            $scope.monitorPointLabelFunction = function (item) {
                if (item) {
                    if (item.name && item.unit) {
                        return item.name + " (" + item.unit + ")";
                    }
                    return item.name;
                }
                return "";
            };
        }]);