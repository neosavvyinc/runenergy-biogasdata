RunEnergy.Dashboard.Controllers.controller('controllers.DocumentationController',
    ['$scope', 'nsServiceExtensions',
        function ($scope, nsServiceExtensions) {

            var apiPrefix = '/field/v1/';

            $scope.user = {
                email: "",
                password: "",
                authentication_token: "D1cbyqySSLbmwREy86NN"
            };

            $scope.api = [
                {
                    "name": "Get Sites",
                    "path": apiPrefix + "sites",
                    "method": "GET"
                },
                {
                    "name": "Get Readings",
                    "path": apiPrefix + "readings",
                    "method": "GET",
                    "params": {
                        "site_id": "7",
                        "class_id": "2",
                        "count": 15
                    }
                },
                {
                    "name": "Create Reading",
                    "path": apiPrefix + "readings/create",
                    "method": "POST",
                    "payload": {"site_id": "7",
                        "class_id": "2",
                        "field_log": {"Name": "Charlie Watts"},
                        "reading": {"Methane": String(parseInt(Math.random() * 100)),
                            "Carbon Dioxide": String(parseInt(Math.random() * 100)),
                            "Oxygen": String(parseInt(Math.random() * 100)),
                            "Pressure": String(parseInt(Math.random() * 100))}}
                }
            ];

            $scope.stringify = JSON.stringify;


            //Watchers
            $scope.$watch('user.authentication_token', function (val) {
                if (val) {
                    for (var i = 0; i < $scope.api.length; i++) {
                        if ($scope.api[i].method === 'POST') {
                            $scope.api[i].payload = $scope.api[i].payload || {};
                            $scope.api[i].payload["authentication_token"] = val;
                        } else {
                            $scope.api[i].params = $scope.api[i].params || {};
                            $scope.api[i].params["authentication_token"] = val;
                        }
                    }
                }
            });

            //Action Handlers
            $scope.onGetToken = function () {
                nsServiceExtensions.
                    request({method: 'POST', url: apiPrefix + 'token/create', data: $scope.user}).then(
                    function (result) {
                        $scope.user.authentication_token = result.token;
                    },
                    function () {
                        $scope.error = "Bad username or password combination.";
                    }
                );
            };

        }]);