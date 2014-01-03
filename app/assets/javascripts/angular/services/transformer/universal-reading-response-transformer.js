RunEnergy.Dashboard.Transformers.factory('services.transformer.UniversalReadingResponseTransformer',
    function () {
        return function (data) {
            if (_.isString(data)) {
                data = JSON.parse(data);
            }
            if (data && data.length) {
                data = _.map(data, function (reading) {
                    reading.data['Date Time'] = reading.taken_at ? moment(reading.taken_at).format('DD/MM/YY, HH:mm:ss') : '';
                    return reading.data;
                });
            }
            return data;
        };
    });