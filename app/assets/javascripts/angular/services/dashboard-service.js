RunEnergy.Dashboard.Services.factory('service.DashboardService',
    ['core.extensions.ServiceExtensions', "constants.Routes",
        function (serviceExtensions, routes) {
            return {
                getCurrentUser: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.USER.READ
                    });
                },
                getCustomers: function () {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: routes.DASHBOARD.CUSTOMERS.READ
                    });
                },
                getEntitledLocations: function (customerId) {
                    var url = routes.DASHBOARD.LOCATIONS.READ;
                    if (customerId) {
                        url = RunEnergy.Dashboard.Utils.RequestUrlUtils.withParams(url, {customerId: customerId});
                    }
                    return serviceExtensions.request({
                        method: 'GET',
                        url: url
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
                getAllFlareMonitorData: function (flareSpecificationId, startDate, endDate, startTime, endTime, start, end) {
                    return serviceExtensions.request({
                        method: 'GET',
                        url: RunEnergy.Dashboard.Utils.RequestUrlUtils.withParams(routes.DASHBOARD.FLARE_MONITOR_DATA.READ,
                            {flareSpecificationId: flareSpecificationId,
                                startDate: startDate,
                                endDate: endDate,
                                startTime: startTime,
                                endTime: endTime,
                                start: start,
                                end: end || (parseInt(start) + 1)}
                        )
                    });
                },
                getCSVExport: function (flareSpecificationId, startDate, endDate, startTime, endTime, filters) {
                    return serviceExtensions.request({
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
