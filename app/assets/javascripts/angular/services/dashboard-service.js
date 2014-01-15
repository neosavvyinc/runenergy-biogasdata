RunEnergy.Dashboard.Services.factory('service.DashboardService',
    ['nsServiceExtensions', "constants.Routes",
        function (nsServiceExtensions, routes) {
            return {
                getCurrentUser: function () {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.USER.READ
                    });
                },
                getCustomers: function () {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.CUSTOMERS.READ
                    });
                },
                getEntitledLocations: function (customerId) {
                    var url = routes.DASHBOARD.LOCATIONS.READ;
                    if (customerId) {
                        url = new Neosavvy.Core.Builders.RequestUrlBuilder(url).
                            addParam("customerId", customerId).
                            build();
                    }
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: url
                    });
                },
                getEntitledFlareDeployments: function () {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.FLARE_DEPLOYMENTS.READ
                    });
                },
                getEntitledFlareSpecifications: function () {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.FLARE_SPECIFICATIONS.READ
                    });
                },
                getAllFlareMonitorData: function (flareSpecificationId, startDate, endDate, startTime, endTime, start, end) {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DASHBOARD.FLARE_MONITOR_DATA.READ).
                            addParam({flareSpecificationId: flareSpecificationId,
                                startDate: startDate,
                                endDate: endDate,
                                startTime: startTime,
                                endTime: endTime,
                                start: start,
                                end: end || (parseInt(start) + 1)}).build()
                    });

                },
                getCSVExport: function (flareSpecificationId, startDate, endDate, startTime, endTime, filters) {
                    return nsServiceExtensions.request({
                        method: 'POST',
                        url: routes.DASHBOARD.CSV_EXPORT.CREATE,
                        headers: {
                            Accept: 'application/json, text/javascript, */*'
                        },
                        data: {
                            flareSpecificationId: flareSpecificationId,
                            startDate: startDate,
                            endDate: endDate,
                            startTime: startTime,
                            endTime: endTime,
                            filters: filters
                        }
                    });
                }
            };

        }]);
