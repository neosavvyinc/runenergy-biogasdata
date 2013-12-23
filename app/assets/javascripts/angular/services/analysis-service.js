RunEnergy.Dashboard.Services.factory('services.AnalysisService',
    ['nsServiceExtensions', 'constants.Routes',
        function (nsServiceExtensions, routes) {
            return {
                readings: function (operatorId, siteId, sectionId, assetId) {
                    if (siteId) {
                        return nsServiceExtensions.request({
                            method: 'GET',
                            url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.ANALYSIS.READINGS).
                                paramReplace(":site_id", siteId).
                                build()
                        });
                    }
                    else {
                        throw "You must pass in a siteId to get any arbitrary readings.";
                    }
                }
            };
        }]);