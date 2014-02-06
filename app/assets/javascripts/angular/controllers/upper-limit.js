RunEnergy.Dashboard.Controllers.controller('controllers.UpperLimit',
    ['$scope',
        '$controller',
        function ($scope,
                  $controller) {

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

        }]);