RunEnergy.Dashboard.Services.factory('services.DataInputService',
    ['nsServiceExtensions', 'constants.Routes', 'services.transformer.DataInputCreateTransformer',
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
                importCsv: function(data) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.IMPORT,
                        data: data
                    });
                }
            };
        }]);