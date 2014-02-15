RunEnergy.Dashboard.Transformers.factory('services.transformer.UniversalReadingResponseTransformer',
    function () {
        var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
        return function (data, includeId) {
            if (_.isString(data)) {
                data = JSON.parse(data);
            }
            if (data && data.length) {
                data = _.map(data, function (reading) {
                    if (reading.id && includeId) {
                        reading.data.id = reading.id;
                    }
                    reading.data['Date Time'] = reading.taken_at ? moment(reading.taken_at).format('DD/MM/YY, HH:mm:ss') : '';
                    reading.data['Asset'] = hpGet(reading, 'asset.unique_identifier');
                    return reading.data;
                });
            }
            return data;
        };
    });