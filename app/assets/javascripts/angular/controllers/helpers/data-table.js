RunEnergy.Dashboard.Controllers.controller('controllers.helpers.DataTable',
    ['$scope',
        function ($scope) {

            $scope.getColumnLabel = memoize(function (key, monitorPoint, monitorLimit) {
                if (key && monitorPoint && monitorPoint.unit) {
                    var val = key + " (" + monitorPoint.unit + ")";
                    return _.isUndefined(monitorLimit) ? val : val + " Limit: " + monitorLimit;
                }
                return key;
            });

        }]);