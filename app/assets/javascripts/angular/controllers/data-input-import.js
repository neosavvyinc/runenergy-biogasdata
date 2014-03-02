RunEnergy.Dashboard.Controllers.controller('controllers.DataInputImportController',
    ['$scope',
        '$location',
        '$filter',
        'nsRailsService',
        'constants.Routes',
        'services.DataInputService',
        'services.transformer.UniversalReadingResponseTransformer',
        'values.NewDataValues',
        function ($scope, $location, $filter, nsRailsService, routes, dataInputService, readingTransformer, newDataValues) {
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
                assetColumnName: null,
                dateColumnName: null,
                dateFormat: null
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

            var deregB = $scope.$watch('readingMods.dateColumnName', function (val) {
                if (val) {
                    $scope.readingMods.dateFormat = '%d-%b-%y';
                    deregB();
                }
            });

            //Action Handlers
            function _matchedColumns() {
                return ((_.keys($scope.readingMods.columnToMonitorPointMappings).length +
                    _.keys($scope.readingMods.deletedColumns).length +
                    (isBlank($scope.readingMods.dateColumnName) ? 2 : 3)) >= _.keys($scope.data[0]).length);
            }

            $scope.onCompleteImport = function () {
                var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
                $scope.error = "";
                if (!isBlank($scope.readingMods.assetColumnName)) {
                    if (!isBlank($scope.readingDate) || !isBlank($scope.readingMods.dateColumnName)) {
                        //+2 for the hashKey and the assetColumnName
                        if (_matchedColumns()) {
                            $scope.loading = true;
                            nsRailsService.request({
                                method: 'POST',
                                url: routes.DATA_INPUT.COMPLETE_IMPORT,
                                data: {
                                    site_id: hpGet(newDataValues, 'selectedSite.id'),
                                    monitor_class_id: hpGet(newDataValues, 'selectedMonitorClass.id'),
                                    asset_column_name: $scope.readingMods.assetColumnName,
                                    readings: $scope.data,
                                    reading_date: $filter('reDateToEpoch')($scope.readingDate),
                                    reading_mods: {
                                        deleted_row_indices: $scope.readingMods.deletedRowIndices,
                                        deleted_columns: $scope.readingMods.deletedColumns,
                                        column_to_monitor_point_mappings: $scope.readingMods.columnToMonitorPointMappings,
                                        date_column_name: $scope.readingMods.dateColumnName,
                                        date_format: $scope.readingMods.dateFormat
                                    }
                                }
                            }).then(
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
                                    $scope.error = error;
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
                if ($scope.readingMods.dateColumnName !== column) {
                    $scope.readingMods.assetColumnName = column;
                }
            };

            $scope.onSetDateColumn = function (column) {
                if ($scope.readingMods.assetColumnName !== column) {
                    $scope.readingMods.dateColumnName = column;
                }
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