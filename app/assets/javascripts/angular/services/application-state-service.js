RunEnergy.Dashboard.Services.factory('services.ApplicationStateService',
    ['nsServiceExtensions',
        'constants.Routes',
        '$angularCacheFactory',
        function (nsServiceExtensions,
                  routes,
                  angularCacheFactory) {

            return {
                lastUrlParams: function() {
                    return nsServiceExtensions.request({
                        method: 'GET',
                        url: routes.APPLICATION_STATE.LAST_URL_PARAMS
                    })
                }
            };
        }]);