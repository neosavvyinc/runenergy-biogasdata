RunEnergy.Dashboard.Controllers.controller('controllers.visualizations.MonitorPointProgress',
    ['$scope',
        function ($scope) {

            //Initialization
            $scope.data = [{}];

            var monitorPointWatch = $scope.$watch('monitorPoint', function (val) {
                if (val && val.id) {
                    $scope.data[0].key = val.name;
                    monitorPointWatch();
                }
            });
            var valuesWatch = $scope.$watch('values', function (val) {
                if (val && val.length) {
                    $scope.data[0].values = val;
                    valuesWatch();
                }
            });

        }]);