RunEnergy.Dashboard.Filters.filter('reCollectionOrderedProperties', function () {
    var _hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
    //Caching this because it will usually be calculated once
    var _getOrderMap = memoize(function (ordering) {
        if (ordering) {
            var _hash = {};
            _.forEach(ordering.split(","), function (p, idx) {
                _hash[p.trim().toLowerCase()] = idx;
            });
            return _hash;
        }
    });

    //Cache the values because easier than calling lifecycle stuff
    return memoize(function (value, ordering, property) {
        if (value && ordering) {
            var _orderMap = _getOrderMap(ordering);
            value = _.sortBy(value, function (item) {
                var prop = _hpGet(item, (property || 'id'));
                return _orderMap[prop ? String(prop).toLowerCase() : prop];
            });
        }
        return value;
    });
});