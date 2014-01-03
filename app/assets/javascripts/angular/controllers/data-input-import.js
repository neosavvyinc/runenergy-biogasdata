RunEnergy.Dashboard.Controllers.controller('controllers.DataInputImportController',
    ['$scope', 'services.DataInputService', 'services.transformer.UniversalReadingResponseTransformer',
        function ($scope, dataInputService, readingTransformer) {

            //Watchers
            var dereg = $scope.$watch('data', function(val) {
                if (val && val.length) {
                    $scope.data = readingTransformer(val);
                    dereg();
                }
            })

        }]);