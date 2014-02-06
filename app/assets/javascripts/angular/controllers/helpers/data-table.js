RunEnergy.Dashboard.Controllers.controller('controllers.helpers.DataTable',
    ['$scope',
        function ($scope) {

            if (!$scope.readingMods) {
                $scope.readingMods = {
                    deletedRowIndices: [],
                    deletedColumns: {},
                    columnToMonitorPointMappings: {},
                    assetColumnName: null
                };
            }

            //Action Handlers
            $scope.onRemoveRow = function (index) {
                var indexOf = $scope.readingMods.deletedRowIndices.indexOf(index);
                if (indexOf === -1) {
                    $scope.readingMods.deletedRowIndices.push(index);
                } else {
                    $scope.readingMods.deletedRowIndices.splice(indexOf, 1);
                }
            };

            //Getters
            $scope.getColumnLabel = memoize(function (key, monitorPoint) {
                if (key && monitorPoint && monitorPoint.unit) {
                    return key + " (" + monitorPoint.unit + ")";
                }
                return key;
            });

            $scope.getRowVariation = function (index, optionA, optionB) {
                return ($scope.readingMods.deletedRowIndices.indexOf(index) === -1 ? optionA : optionB);
            };

        }]);