//Logical
RunEnergy.Dashboard.Filters.filter('logicalIif', function () {
    return function (input, trueValue, falseValue) {
        return input ? trueValue : falseValue;
    };
});

//Numeric
RunEnergy.Dashboard.Filters.filter('numericExpression', ['$interpolate', '$parse', function ($interpolate, $parse) {
    return function (data, expressionsAndIndexes) {
        if (data && data.length) {
            if (expressionsAndIndexes && expressionsAndIndexes.length) {
                return data.filter(function (item) {
                    for (var i = 0; i < expressionsAndIndexes.length; i++) {
                        var expressionAndProperty = expressionsAndIndexes[i];
                        if (expressionAndProperty.expression && /\d/.test(expressionAndProperty.expression) && !$parse(String(item[parseInt(expressionAndProperty.index)]) + expressionAndProperty.expression)()) {
                            return false;
                        }
                    }
                    return true;
                });
            }
            return data;
        }
        return [];
    };
}]);

RunEnergy.Dashboard.Filters.filter('numericFilterRound', function () {
    return function (value, significantDigits) {
        if (value !== undefined && value !== null) {
            var rounded = Math.round(parseFloat(value) * Math.pow(10, significantDigits));
            var str = String(rounded);
            return rounded && significantDigits ? str.slice(0, str.length - significantDigits) + "." + str.slice(str.length - significantDigits, str.length) : str;
        }
        return value;
    };
});

RunEnergy.Dashboard.Filters.filter('ifNumberNumericFilterRound',
    ['$filter',
        function ($filter) {
            return function (value, significantDigits) {
                if (RunEnergy.Dashboard.Utils.NumberUtils.isNumber(value)) {
                    return $filter('numericFilterRound')(value, significantDigits);
                }
                return value;
            };
        }]);


//Collection
RunEnergy.Dashboard.Filters.filter('collectionFilterProperty', function () {
    return function (collection, property, value) {
        if (collection && value) {
            return collection.filter(function (item) {
                return (RunEnergy.Dashboard.Utils.MapUtils.get(item, property) === value);
            });
        }
        return collection;
    };
});

RunEnergy.Dashboard.Filters.filter('collectionPage', function () {
    return function (collection, page, count) {
        if (collection && collection.length) {
            if (page !== undefined && count) {
                var start = page * count;
                return collection.slice(start, Math.min(start + count, collection.length));
            }
        }
        return collection;
    };
});