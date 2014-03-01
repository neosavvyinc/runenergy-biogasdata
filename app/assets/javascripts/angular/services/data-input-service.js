RunEnergy.Dashboard.Services.factory('services.DataInputService',
    ['nsServiceExtensions',
        'constants.Routes',
        'services.transformer.DataInputCreateTransformer',
        function (nsServiceExtensions, routes) {
            return {
                createReading: function (siteId, monitorClassId, assetUniqueIdentifier, fieldLog, reading, date_time) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.CREATE,
                        data: {
                            site_id: siteId,
                            monitor_class_id: monitorClassId,
                            asset_unique_identifier: assetUniqueIdentifier,
                            field_log: fieldLog,
                            reading: reading,
                            date_time: (date_time ? parseInt(date_time.getTime() / 1000) : date_time)
                        }
                    });
                },
                createMonitorPoint: function (siteId, monitorClassId, name, unit) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.CREATE_MONITOR_POINT,
                        data: {
                            site_id: siteId,
                            monitor_class_id: monitorClassId,
                            name: name,
                            unit: unit
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
                }
            };
        }]);