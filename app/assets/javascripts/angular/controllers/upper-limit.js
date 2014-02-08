RunEnergy.Dashboard.Controllers.controller('controllers.UpperLimit',
    ['$scope',
        '$controller',
        function ($scope,
                  $controller) {
            var isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

            //Initialization
            $scope.limitKey = 'upper_limit';

            //Helpers
            $controller('controllers.helpers.DataTable', {$scope: $scope});

            //Initialization
            $scope.data = [];

            //Watches
            $scope.$watch('upperLimits', function (val) {
                if (val && val.length) {
                    $scope.data = val;
                }
            });

            //Getters
            $scope.getOutsideLimitClass = function (value, monitorLimit) {
                if (!isBlank(value) && monitorLimit && !isBlank(monitorLimit.upper_limit)) {
                    return (parseFloat(value) > parseFloat(monitorLimit.upper_limit)) ? 'outside' : '';
                }
                return '';
            };

        }]);