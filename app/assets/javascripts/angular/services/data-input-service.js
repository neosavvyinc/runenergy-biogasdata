RunEnergy.Dashboard.Services.factory('services.DataInputService',
    ['nsServiceExtensions',
        'constants.Routes',
        'services.transformer.DataInputCreateTransformer',
        function (nsServiceExtensions, routes) {
            return {
                createReading: function (siteId, monitorClassId, assetUniqueIdentifier, fieldLog, reading, date, time) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.CREATE,
                        data: {
                            site_id: siteId,
                            monitor_class_id: monitorClassId,
                            asset_unique_identifier: assetUniqueIdentifier,
                            field_log: fieldLog,
                            reading: reading,
                            date: date,
                            time: time
                        }
                    });
                },
                readings: function (siteId, monitorClassId) {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DATA_INPUT.READINGS).
                            paramReplace({':site_id': siteId, ':monitor_class_id': monitorClassId}).
                            build()
                    });
                },
                completeImportCsv: function (readings, columnToMonitorPointMappings, deletedRowIndices, deletedColumns, siteId, monitorClassId, assetColumnName) {
                    if (readings && readings.length && columnToMonitorPointMappings) {
                        return nsServiceExtensions.request({
                            method: 'POST',
                            url: routes.DATA_INPUT.COMPLETE_IMPORT,
                            data: {
                                site_id: siteId,
                                monitor_class_id: monitorClassId,
                                asset_column_name: assetColumnName,
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