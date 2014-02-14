RunEnergy.Dashboard.Transformers.factory('service.transformer.UniversalStripAngularKeysRequest',
    function () {
        return function (data) {
            if (data) {
                delete data.$$hashKey;
                data = JSON.stringify(data);
            }
            return data;
        };
    });