RunEnergy.Dashboard.Services.factory('services.DataInputService',
    ['nsServiceExtensions', 'constants.Routes', 'services.transformer.DataInputCreateTransformer',
        function (nsServiceExtensions, routes, transformDataInputCreate) {
            return {
                createReading: function (fieldLog, reading) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.CREATE,
                        data: {
                            field_log: fieldLog,
                            reading: reading
                        },
                        transformRequest: transformDataInputCreate
                    });
                },
                readings: function (assetId, monitorClassId) {

                }
            };
        }]);