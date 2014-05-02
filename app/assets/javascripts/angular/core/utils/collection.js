var _re = _re || {};
(function (namespace) {
    var _hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
    var _isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

    function _blankOrNaN(val) {
        return _isBlank(val) || _.isNaN(val);
    }

    function _baseLine(val, min, max, minNotBlank, maxNotBlank) {
        val = parseFloat(val);
        /* Compress towards 0 */
        if (minNotBlank) {
            val = val <= min ? min : val - min;
        }
        if (maxNotBlank) {
            val = val >= max ? max : val;
        }
        return val;
    }

    function _spread(val, median, min, max, minValue, maxValue, minRange, maxRange) {
        if (val === median || val <= minValue || val >= maxValue) {
            return Math.min(Math.max(val, min), max);
        } else if (val < median) {
            return val * ((minRange - (median - val)) / minRange);
        } else {
            return val * ((maxRange - val) / maxRange);
        }
    }

    namespace.collection = {
        compress: function (collection, min, max, percent, options) {
            var _maxNotBlank = !_isBlank(max), _minNotBlank = !_isBlank(min);
            if (_hpGet(collection, 'length') && (_maxNotBlank || _minNotBlank || !_isBlank(percent))) {
                collection = _(collection).reject(_blankOrNaN).map(function (item) {
                    if (_hpGet(options, 'property')) {

                    } else {
                        return _baseLine(item, min, max, _minNotBlank, _maxNotBlank);
                    }
                }).valueOf();

                /* Calculate Medians */
                var _median = _.median(collection), _min = _.min(collection), _max = _.max(collection);

                return _.map(collection, function (item) {
                    if (_hpGet(options, 'property')) {

                    } else {
                        return _spread(item, _median, min, max, _min, _max, _median - _min, _max - _median);
                    }
                });
            }
            return collection;
        }
    };
})(_re);