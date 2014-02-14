RunEnergy.Dashboard.Filters.filter('reCollectionOrderedPairs', function () {
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
    return memoize(function (value, ordering) {
        if (value) {
            value = _.pairs(value);
            if (ordering) {
                var _orderMap = _getOrderMap(ordering);
                value = _.sortBy(value, function (item) {
                    return _orderMap[item[0].toLowerCase()] ;
                });
            }

        }
        return value;
    });
});