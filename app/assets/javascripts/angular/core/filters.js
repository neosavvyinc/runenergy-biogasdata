//Numeric
RunEnergy.Dashboard.Filters.filter('numericExpressionConversion', ['$interpolate', '$parse', function ($interpolate, $parse) {
    return function (value) {
        if (value) {
            return value.replace(/=/g, "==");
        }
        return value;
    };
}]);

RunEnergy.Dashboard.Filters.filter('numericExpression', ['$interpolate', '$parse', function ($interpolate, $parse) {
    return function (data, expressionsAndIndexes, property) {
        if (data && data.length) {
            if (expressionsAndIndexes && expressionsAndIndexes.length) {
                return data.filter(function (item) {
                    for (var i = 0; i < expressionsAndIndexes.length; i++) {
                        var expressionAndProperty = expressionsAndIndexes[i];
                        var expression = expressionAndProperty.expression.replace(/=/g, "==");
                        var value = (property ? item[parseInt(expressionAndProperty.index)][property] : item[parseInt(expressionAndProperty.index)]);
                        if (expression && /\d/.test(expression) && !$parse(String(value) + expression)()) {
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
            var negative = parseFloat(value) < 0;
            var rounded = Math.round(parseFloat(Math.abs(value)) * Math.pow(10, significantDigits));
            var str = String(rounded);
            if (rounded && significantDigits) {
                if ((str.length - significantDigits) <= 0) {
                    str = "0" + "." + RunEnergy.Dashboard.Utils.NumberUtils.withLeadingZeroes(str, significantDigits);
                } else {
                    str = str.slice(0, str.length - significantDigits) + "." + str.slice(str.length - significantDigits, str.length);
                }
                if (negative) {
                    return ("-" + str);
                }
                return str;
            } else {
                return negative ? "-" + str : str;
            }
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

//Text
RunEnergy.Dashboard.Filters.filter('nsTextProperToSnake', function () {
    return function (value) {
        if (!Neosavvy.Core.Utils.StringUtils.isBlank(value)) {
            return value.replace(/\s{1,}/g, "_").toLowerCase();
        }
        return value;
    };
});
