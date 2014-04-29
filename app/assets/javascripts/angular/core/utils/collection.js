var _re = _re || {};
(function (namespace) {
    var _hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
    var _isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

    function _blankOrNaN(val) {
        return _isBlank(val) || _.isNaN(val);
    }

    function _compare(val, min, max, minNotBlank, maxNotBlank) {
        val = parseFloat(val);
        if (minNotBlank) {
            val = val <= min ? min : val - min;
        }
        if (maxNotBlank) {
            val = val >= max ? max : val;
        }
        return val;
    }

    namespace.collection = {
        compress: function (collection, min, max, percent, options) {
            var _maxNotBlank = !_isBlank(max), _minNotBlank = !_isBlank(min);
            if (_hpGet(collection, 'length') && (_maxNotBlank || _minNotBlank || !_isBlank(percent))) {
                var median = _.median(collection);
                return _(collection).reject(_blankOrNaN).map(function (item) {
                    if (_hpGet(options, 'property')) {

                    } else {
                        return _compare(item, min, max, _minNotBlank, _maxNotBlank);
                    }
                }).valueOf();
            }
            return collection;
        }
    };
})(_re);