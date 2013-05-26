RunEnergy.Dashboard.Services.factory('service.DashboardService',
    ['core.extensions.ServiceExtensions', "constants.Routes",
        function (serviceExtensions, routes) {
            return {
                getEntitledLocations: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.LOCATIONS.READ
                    });
                },
                getEntitledFlareSpecifications: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.FLARE_SPECIFICATIONS.READ
                    });
                },
                getAllFlareMonitorData: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.FLARE_MONITOR_DATA.READ
                    });
                }
            };

        }]);
