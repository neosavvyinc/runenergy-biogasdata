RunEnergy.Dashboard.Controllers.controller('controllers.DataInputImportController',
    ['$scope',
        '$location',
        'services.DataInputService',
        'services.transformer.UniversalReadingResponseTransformer',
        'values.NewDataValues',
        function ($scope, $location, dataInputService, readingTransformer, newDataValues) {
            var isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

            //Initialization
            var monitorLimits;
            $scope.columnNameRow = 1;
            $scope.firstDataRow = 2;
            $scope.readingDate = null;
            $scope.readingMods = {
                deletedRowIndices: [],
                deletedColumns: {},
                columnToMonitorPointMappings: {},
                assetColumnName: null
            };
            $scope.approvals = {
                upperLimit: false,
                lowerLimit: false
            };
            $scope.newDataValues = newDataValues;

            //Watchers
            var dereg = $scope.$watch('data', function (val) {
                if (val && val.length) {
                    $scope.data = readingTransformer(val);
                    newDataValues.enable.createMonitorPoint = true;
                    dereg();
                }
            });

            function _checkFieldValidity() {
                $scope.requiredFieldsMissing = (isBlank($scope.columnNameRow) || isBlank($scope.firstDataRow));
            }

            $scope.$watch('columnNameRow', _checkFieldValidity);
            $scope.$watch('firstDataRow', _checkFieldValidity);

            //Load up import column mappings from the cache of the request
            $scope.$watch('newDataValues.selectedLocationsMonitorClass', function (val) {
                if (val) {
                    if (val.asset_column_name) {
                        $scope.readingMods.assetColumnName = val.asset_column_name;
                    }
                    if (val.column_cache) {
                        $scope.readingMods.columnToMonitorPointMappings = val.column_cache;
                    }
                    if (val.deleted_column_cache) {
                        $scope.readingMods.deletedColumns = val.deleted_column_cache;
                    }
                }
            });

            $scope.$watch('approvals', function (val) {
                if (val && val.upperLimit && val.lowerLimit) {
                    window.location = '/data_analysis#' + window.location.search;
                }
            }, true);

            //Action Handlers
            var _epochDateFor = function (dateTime) {
                if (dateTime) {
                    return parseInt(dateTime.getTime() / 1000)
                }
                return dateTime;
            };

            $scope.onCompleteImport = function () {
                var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
                $scope.error = "";
                if (!isBlank($scope.readingMods.assetColumnName)) {
                    if (!isBlank($scope.readingDate)) {
                        //+2 for the hashKey and the assetColumnName
                        if ((_.keys($scope.readingMods.columnToMonitorPointMappings).length +
                            _.keys($scope.readingMods.deletedColumns).length + 2) === _.keys($scope.data[0]).length) {
                            $scope.loading = true;
                            dataInputService.completeImportCsv(
                                    $scope.data,
                                    $scope.readingMods.columnToMonitorPointMappings,
                                    $scope.readingMods.deletedRowIndices,
                                    $scope.readingMods.deletedColumns,
                                    hpGet(newDataValues, 'selectedSite.id'),
                                    hpGet(newDataValues, 'selectedMonitorClass.id'),
                                    $scope.readingMods.assetColumnName,
                                    _epochDateFor($scope.readingDate)
                                ).then(
                                function (result) {
                                    if (result) {
                                        //Stateful goodness
                                        $scope.loading = false;
                                        $scope.data = null;
                                        newDataValues.enable.createMonitorPoint = false;

                                        //Monitor limit info needed
                                        $scope.monitorLimits = result.monitor_limits;
                                        $scope.upperLimits = readingTransformer(result.upper_limits, true);
                                        $scope.lowerLimits = readingTransformer(result.lower_limits, true);

                                        //Set approvals if they are empty
                                        $scope.approvals.upperLimit = (!$scope.upperLimits || !$scope.upperLimits.length)
                                        $scope.approvals.lowerLimit = (!$scope.lowerLimits || !$scope.lowerLimits.length)
                                    }
                                },
                                function (error) {
                                    $scope.error = "You must select a location, monitor class, and asset column.";
                                });
                        }
                        else {
                            $scope.error = "You have not assigned or removed every column.";
                        }
                    } else {
                        $scope.error = "You must specify a reading date for the import.";
                    }
                } else {
                    $scope.error = "Please select an asset column for your spreadsheet.";
                }
            };

            $scope.onSetAssetColumn = function (column) {
                $scope.readingMods.assetColumnName = column;
            };

            $scope.onSubmit = function (e) {
                if (!newDataValues.selectedSite) {
                    $scope.error = 'You must select a site before uploading';
                    e.preventDefault();
                } else if (!newDataValues.selectedMonitorClass) {
                    $scope.error = 'You must select a monitor class before uploading';
                    e.preventDefault();
                }
            };

            //Getters
            $scope.getFormPostUrl = function (base, newDataValues) {
                var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
                var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(base);
                if (hpGet(newDataValues, 'selectedLandfillOperator.id')) {
                    builder.addParam('operator', hpGet(newDataValues, 'selectedLandfillOperator.id'));
                }
                if (hpGet(newDataValues, 'selectedSite.id')) {
                    builder.addParam('site', hpGet(newDataValues, 'selectedSite.id'));
                }
                if (hpGet(newDataValues, 'selectedMonitorClass.id')) {
                    builder.addParam('monitor_class', hpGet(newDataValues, 'selectedMonitorClass.id'));
                }
                if (hpGet(newDataValues, 'selectedSection.id')) {
                    builder.addParam('section', hpGet(newDataValues, 'selectedSection.id'));
                }
                if (hpGet(newDataValues, 'selectedAsset.id')) {
                    builder.addParam('asset', hpGet(newDataValues, 'selectedAsset.id'));
                }
                return builder.build();
            };

        }]);