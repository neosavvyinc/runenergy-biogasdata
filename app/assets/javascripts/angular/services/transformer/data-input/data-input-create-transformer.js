RunEnergy.Dashboard.Transformers.factory('services.transformer.DataInputCreateTransformer',
    ['$filter',
        function ($filter) {
            return function(data) {
                return JSON.stringify(data);
            };
        }]);