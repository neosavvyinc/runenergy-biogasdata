RunEnergy.Dashboard.Filters.filter('reStrBlankLessThan', function () {
    return function (value, min, additionalCondition) {
        if (additionalCondition === undefined || additionalCondition) {
            if (min === undefined) {
                min = 0;
            }
            return _.isNaN(value) || parseFloat(value) < min ? '' : value;
        } else {
            return value;
        }
    };
});