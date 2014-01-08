RunEnergy.Dashboard.Controllers.controller('controllers.ImportTable',
    ['$scope',
        function ($scope) {

            if (!$scope.readingMods) {
                throw "You must define the readingMods on the scope for the import table.";
            }

            //Action Handlers
            $scope.onRemoveRow = function (index) {
                var indexOf = $scope.readingMods.deletedRowIndices.indexOf(index);
                if (indexOf === -1) {
                    $scope.readingMods.deletedRowIndices.push(index);
                } else {
                    $scope.readingMods.deletedRowIndices.splice(indexOf, 1);
                }
            };

            $scope.onRemoveColumn = function (name) {
                if ($scope.readingMods.deletedColumns[name]) {
                    delete $scope.readingMods.deletedColumns[name];
                } else {
                    $scope.readingMods.deletedColumns[name] = true;
                }
            };

            //Getters
            $scope.getRowVariation = function (index, optionA, optionB) {
                return ($scope.readingMods.deletedRowIndices.indexOf(index) === -1 ? optionA : optionB);
            };

            $scope.getColumnVariation = function(key, optionA, optionB) {
                return (!$scope.readingMods.deletedColumns[key] ? optionA : optionB);
            };
        }]);