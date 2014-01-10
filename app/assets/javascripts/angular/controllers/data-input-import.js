RunEnergy.Dashboard.Controllers.controller('controllers.DataInputImportController',
    ['$scope',
        '$location',
        'services.DataInputService',
        'services.transformer.UniversalReadingResponseTransformer',
        'values.NewDataValues',
        function ($scope, $location, dataInputService, readingTransformer, newDataValues) {

            //Initialization
            $scope.columnNameRow = 1;
            $scope.firstDataRow = 2;
            $scope.readingMods = {
                deletedRowIndices: [],
                deletedColumns: {},
                columnToMonitorPointMappings: {}
            };
            $scope.newDataValues = newDataValues;

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

            //Getters
            $scope.getFormPostUrl = memoize(function (base, newDataValues) {
                var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
                try {
                    return new Neosavvy.Core.Builders.RequestUrlBuilder(base)
                        .addParam('operator', hpGet(newDataValues, 'selectedLandfillOperator.id'))
                        .addParam('site', hpGet(newDataValues, 'selectedSite.id'))
                        .addParam('monitor_class', hpGet(newDataValues, 'selectedMonitorClass.id'))
                        .addParam('section', hpGet(newDataValues, 'selectedSection.id'))
                        .addParam('asset', hpGet(newDataValues, 'selectedAsset.id'))
                        .build();
                } catch (e) {
                    return "";
                }
            });

        }]);