RunEnergy.Dashboard.Controllers.controller('controllers.DataInputImportController',
    ['$scope', 'services.DataInputService',
        function ($scope, dataInputService) {
            $scope.onImport = function () {
                if ($scope.form) {
                    $scope.form.submit(function() {
                        var data = this.serialize();
                        dataInputService.importCsv(data).then(function(result) {

                        });
                        //Prevents default behavior
                        return false;
                    });
                }
            };
        }]);