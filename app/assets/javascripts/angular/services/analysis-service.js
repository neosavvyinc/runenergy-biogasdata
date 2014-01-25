RunEnergy.Dashboard.Services.factory('services.AnalysisService',
    ['nsServiceExtensions', 'constants.Routes',
        function (nsServiceExtensions, routes) {
            return {
                readings: function (siteId, monitorClassId, startDateTime, endDateTime) {
                    if (siteId && monitorClassId) {
                        var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(routes.ANALYSIS.READINGS).
                            paramReplace(":site_id", siteId).
                            paramReplace(":monitor_class_id", monitorClassId);
                        if (startDateTime) {
                            builder.addParam('start_date_time', parseInt(startDateTime.getTime() / 1000));
                        }
                        if (endDateTime) {
                            builder.addParam('end_date_time', parseInt(endDateTime.getTime() / 1000));
                        }
                        return nsServiceExtensions.request({
                            method: 'GET',
                            url: builder.build()
                        });
                    }
                    else {
                        throw "You must pass in a siteId to get any arbitrary readings.";
                    }
                },
                monitorPoints: function (assetId) {
                    if (assetId) {
                        return nsServiceExtensions.request({
                            method: 'GET',
                            url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.ANALYSIS.MONITOR_POINTS).
                                paramReplace(":asset_id", assetId).
                                build()
                        });
                    } else {
                        throw "You must pass in an assetId to get monitorPoints for an asset.";
                    }
                }
            };
        }]);