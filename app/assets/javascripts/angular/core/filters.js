RunEnergy.Dashboard.Filters.filter('logicalIif', function () {
    return function (input, trueValue, falseValue) {
        return input ? trueValue : falseValue;
    };
});