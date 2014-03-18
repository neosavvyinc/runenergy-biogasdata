RunEnergy.Dashboard.Controllers.controller('controllers.DataCollision',
    ['$scope',
        '$rootScope',
        'nsRailsService',
        'constants.Routes',
        function ($scope, $rootScope, nsRailsService, routes) {

            /* Action Handlers */
            $scope.onResolve = function (data) {
                nsRailsService.request({
                    method: 'POST',
                    url: routes.DATA_COLLISION.RESOLVE,
                    data: data
                }).then(function () {
                    $rootScope.$broadcast('REMOVE_FROM_DOM', data);
                });
            };

        }]);