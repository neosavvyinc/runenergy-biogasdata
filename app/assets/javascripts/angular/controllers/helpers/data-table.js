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
                    $scope.loading = true;
                    return nsRailsService.request({
                        method: 'POST',
                        url: routes.DATA_INPUT.APPROVE_LIMIT_BREAKING_SET,
                        data: _.merge({
                            readings: $scope.data,
                            type: $scope.limitKey,
                            monitorLimitIds: _.map($scope.monitorLimits, 'id')
                        }, $scope.readingMods)
                    }).then(function (result) {
                        $scope.loading = false;
                        $scope.data = null;
                        if ($scope.limitKey == 'upper_limit') {
                            $scope.upperLimits = null;
                            $scope.approvals.upperLimit = true;
                        } else {
                            $scope.lowerLimits = null;
                            $scope.approvals.lowerLimit = true;
                        }
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