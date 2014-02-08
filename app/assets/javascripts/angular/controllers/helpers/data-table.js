RunEnergy.Dashboard.Controllers.controller('controllers.helpers.DataTable',
    ['$scope',
        'nsRailsService',
        'constants.Routes',
        function ($scope,
                  nsRailsService,
                  routes) {

            $scope.readingMods = {
                deletedIds: {}
            };

            //Action Handlers
            $scope.onRemoveRow = function (index) {
                var id = String($scope.data[index].id);
                if (!$scope.readingMods.deletedIds[id]) {
                    $scope.readingMods.deletedIds[id] = true;
                } else {
                    delete $scope.readingMods.deletedIds[id];
                }
            };

            $scope.onApproveLimits = function () {
                if ($scope.data && $scope.data.length) {
                    return nsRailsService.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.APPROVE_LIMIT_BREAKING_SET,
                        data: _.merge({
                            readings: $scope.data,
                            type: $scope.limitKey
                        }, $scope.readingMods)
                    });
                } else {
                    throw "There is no data on the scope, this function should not be called.";
                }
            };

            //Getters
            $scope.getColumnLabel = memoize(function (key, monitorPoint) {
                if (key && monitorPoint && monitorPoint.unit) {
                    return key + " (" + monitorPoint.unit + ")";
                }
                return key;
            });

            $scope.getRowVariation = function (index, optionA, optionB) {
                return ($scope.readingMods.deletedRowIndices.indexOf(index) === -1 ? optionA : optionB);
            };

            $scope.getDeleted = function (id) {
                if (id) {
                    return $scope.readingMods.deletedIds[String(id)] || false;
                }
                return false;
            };

        }]);