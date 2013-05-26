//Logical
RunEnergy.Dashboard.Filters.filter('logicalIif', function () {
    return function (input, trueValue, falseValue) {
        return input ? trueValue : falseValue;
    };
});

//Numeric
RunEnergy.Dashboard.Filters.filter('numericExpressipn', ['$interpolate', function ($interpolate) {
    return function (data, expressionsToProperties) {
        if (data && date.length && expressionsToProperties && expressionsToProperties.length) {
            return data.filter(function (item) {
                for (var i = 0; i < expressionsToProperties.length; i++) {
                    var expressionAndProperty = expressionsToProperties[i];
                    if ($interpolate(expressionAndProperty.expression + expressionAndProperty.property) === false) {
                         return false;
                    }
                }
                return true;
            });
        }
        return [];
    };
}]);