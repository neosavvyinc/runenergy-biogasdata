RunEnergy.Dashboard.Services.factory('services.FieldApiService',
    ['nsServiceExtensions',
        function (nsServiceExtensions) {
            var apiPrefix = 'field/v1/';
            return {
                sync: function (deviceUid) {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: new Neosavvy.Core.Builders.RequestUrlBuilder(apiPrefix + 'sync')
                            .addParam('uid', deviceUid)
                            .build()
                    });
                },
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
                        method: 'GET',
                        url: new Neosavvy.Core.Builders.RequestUrlBuilder(apiPrefix + 'readings')
                            .addParam('site_id', siteId)
                            .addParam('class_id', classId)
                            .build()
                    });
                },
                createReading: function (siteId, classId, fieldLog, reading) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: apiPrefix + 'readings/create',
                        data: {
                            site_id: siteId,
                            class_id: classId,
                            field_log: fieldLog,
                            reading: reading
                        }
                    });
                }
            };
        }]);