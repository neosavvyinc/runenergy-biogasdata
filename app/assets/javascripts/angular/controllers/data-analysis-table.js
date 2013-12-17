RunEnergy.Dashboard.Controllers.controller('controllers.DataAnalysisTable',
    ['$scope',
        function ($scope) {

            //Initialization
            $scope.headers = [];
            $scope.data = [];
            $scope.keysToDisplayNames = {};

            //Watchers
            $scope.$watch('data', function (val) {
                if (val.length) {
                    $scope.headers = _.keys(val[0]);
                }
            });

            //Getters
            $scope.getDisplayName = function (key) {
                $scope.keysToDisplayNames[key] || key;
            };

        }]);