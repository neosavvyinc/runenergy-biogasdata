RunEnergy.Dashboard.Services.factory('service.DashboardService',
    ['core.extensions.ServiceExtensions', "constants.Routes",
        function (serviceExtensions, routes) {
            return {
                getCustomers: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.CUSTOMERS.READ
                    });
                },
                getEntitledLocations: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.LOCATIONS.READ
                    });
                },
                getEntitledFlareDeployments: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.FLARE_DEPLOYMENTS.READ
                    });
                },
                getEntitledFlareSpecifications: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.FLARE_SPECIFICATIONS.READ
                    });
                },
                getAllFlareMonitorData: function (flareSpecificationId, startDate, endDate, start, end) {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: RunEnergy.Dashboard.Utils.RequestUrlUtils.withParams(routes.DASHBOARD.FLARE_MONITOR_DATA.READ,
                            {flareSpecificationId: flareSpecificationId, start: start, end: end || (parseInt(start) + 1)}
                        )
                    });
                },
                sendRowsForCSVExport: function(ids) {
                    return serviceExtensions.request({
                        method: 'POST',
                        url: routes.DASHBOARD.CSV_EXPORT,
                        data: ids || []
                    });
                }
            };

        }]);
