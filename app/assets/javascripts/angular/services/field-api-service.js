RunEnergy.Dashboard.Services.factory('services.FieldApiService',
    ['nsServiceExtensions',
        function (nsServiceExtensions) {
            var apiPrefix = 'field/v1/';
            return {
                getSites: function () {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: apiPrefix + 'sites'
                    });
                },
                getMonitorClasses: function () {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: apiPrefix + 'monitor_classes'
                    });
                },
                getReadings: function (siteId, classId) {
                    return nsServiceExtensions.request({
                        method: 'GET'
                    });
                },
                sendReading: function (siteId, classId, fieldLog, reading) {
                    return nsServiceExtensions.request({
                        method: 'POST'
                    });
                }
            };
        }]);