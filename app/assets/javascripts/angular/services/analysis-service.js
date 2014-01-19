RunEnergy.Dashboard.Services.factory('services.AnalysisService',
    ['nsServiceExtensions', 'constants.Routes',
        function (nsServiceExtensions, routes) {
            return {
                readings: function (siteId, monitorClassId) {
                    if (siteId && monitorClassId) {
                        return nsServiceExtensions.request({
                            method: 'GET',
                            url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.ANALYSIS.READINGS).
                                paramReplace(":site_id", siteId).
                                paramReplace(":monitor_class_id", monitorClassId).
                                build()
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