RunEnergy.Dashboard.Controllers.controller('controllers.DocumentationController',
    ['$scope',
        function ($scope) {

            var apiPrefix = '/field/v1/';

            $scope.api = [
                {
                    "path": apiPrefix + "sync",
                    "method": "GET",
                    "params": {"uid": "String"},
                    "payload": null
                }
            ];

        }]);