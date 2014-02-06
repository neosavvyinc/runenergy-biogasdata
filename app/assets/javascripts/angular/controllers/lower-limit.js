RunEnergy.Dashboard.Controllers.controller('controllers.LowerLimit',
    ['$scope',
        '$controller',
        function ($scope, $controller) {

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


        }]);