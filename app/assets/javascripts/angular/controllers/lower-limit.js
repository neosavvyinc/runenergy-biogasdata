RunEnergy.Dashboard.Controllers.controller('controllers.LowerLimit',
    ['$scope',
        '$controller',
        function ($scope, $controller) {
            var isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

            //Initialization
            $scope.limitKey = 'lower_limit';

            //Helpers
            $controller('controllers.helpers.DataTable', {$scope: $scope});

            //Initialization
            $scope.data = [];

            //Watches
            $scope.$watch('lowerLimits', function (val) {
                if (val && val.length) {
                    $scope.data = val;
                }
            });

            //Getters
            $scope.getOutsideLimitClass = function (value, monitorLimit) {
                if (!isBlank(value) && monitorLimit && !isBlank(monitorLimit.lower_limit)) {
                    return (parseFloat(value) < parseFloat(monitorLimit.lower_limit)) ? 'outside' : '';
                }
                return '';
            };
        }]);