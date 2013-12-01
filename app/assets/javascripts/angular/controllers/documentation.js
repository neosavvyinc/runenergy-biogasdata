RunEnergy.Dashboard.Controllers.controller('controllers.DocumentationController',
    ['$scope',
        function ($scope) {

            var apiPrefix = '/field/v1/';

            $scope.api = [
                {
                    "name": "Sync",
                    "path": apiPrefix + "sync",
                    "method": "GET",
                    "params": {"uid": "uid400"}
                },
                {
                    "name": "Get Sites",
                    "path": apiPrefix + "sites",
                    "method": "GET"
                },
                {
                    "name": "Get Monitor Classes",
                    "path": apiPrefix + "monitor_classes",
                    "method": "GET"
                },
                {
                    "name": "Get Readings",
                    "path": apiPrefix + "readings",
                    "method": "GET",
                    "params": {"site_id": "7",
                        "class_id": "2"}
                },
                {
                    "name": "Create Reading",
                    "path": apiPrefix + "readings/create",
                    "method": "POST",
                    "payload": {"site_id": "7",
                        "class_id": "2",
                        "field_log": {"Name":"Charlie Watts"},
                        "reading": {"Methane":"89","Carbon Dioxide":"567","Oxygen":"8","Pressure":"78"}}
                }
            ];

            $scope.stringify = JSON.stringify;

        }]);