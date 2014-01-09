RunEnergy.Dashboard.Services.factory('services.DataInputService',
    ['nsServiceExtensions',
        'constants.Routes',
        'services.transformer.DataInputCreateTransformer',
        function (nsServiceExtensions, routes) {
            return {
                createReading: function (assetId, monitorClassId, fieldLog, reading, date, time) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.CREATE,
                        data: {
                            asset_id: assetId,
                            monitor_class_id: monitorClassId,
                            field_log: fieldLog,
                            reading: reading,
                            date: date,
                            time: time
                        }
                    });
                },
                readings: function (assetId, monitorClassId) {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.READINGS).
                            paramReplace({':asset_id': assetId, ':monitor_class_id': monitorClassId}).
                            build()
                    });
                },
                completeImportCsv: function (readings, columnToMonitorPointMappings, deletedRowIndices, deletedColumns) {
                    if (readings && readings.length && columnToMonitorPointMappings) {
                        return nsServiceExtensions.request({
                            method: 'POST',
                            url: routes.DATA_INPUT.COMPLETE_IMPORT,
                            data: {
                                readings: readings,
                                reading_mods: {
                                    deleted_row_indices: deletedRowIndices,
                                    deleted_columns: deletedColumns,
                                    column_to_monitor_point_mappings: columnToMonitorPointMappings
                                }
                            }
                        });
                    } else {
                        throw "You must provide a readings collection and a mapping of columns to monitor points in order to complete the import.";
                    }
                }
            };
        }]);