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