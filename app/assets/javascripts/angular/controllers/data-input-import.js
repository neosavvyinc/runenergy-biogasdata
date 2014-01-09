RunEnergy.Dashboard.Controllers.controller('controllers.DataInputImportController',
    ['$scope', 'services.DataInputService', 'services.transformer.UniversalReadingResponseTransformer',
        function ($scope, dataInputService, readingTransformer) {

            //Initialization
            $scope.columnNameRow = 1;
            $scope.firstDataRow = 2;
            $scope.readingMods = {
                deletedRowIndices: [],
                deletedColumns: {},
                columnToMonitorPointMappings: {}
            };

            //Watchers
            var dereg = $scope.$watch('data', function (val) {
                if (val && val.length) {
                    $scope.data = readingTransformer(val);
                    dereg();
                }
            });

            function _checkFieldValidity() {
                var isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;
                $scope.requiredFieldsMissing = (isBlank($scope.columnNameRow) || isBlank($scope.firstDataRow));
            }

            $scope.$watch('columnNameRow', _checkFieldValidity);
            $scope.$watch('firstDataRow', _checkFieldValidity);

            //Action Handlers
            $scope.onCompleteImport = function () {
                dataInputService.completeImportCsv(
                        $scope.data,
                        $scope.readingMods.columnToMonitorPointMappings,
                        $scope.readingMods.deletedRowIndices,
                        $scope.readingMods.deletedColumns
                    ).then(function (result) {
                        console.log("RECEIVED DATA!");
                    });
            };

        }]);