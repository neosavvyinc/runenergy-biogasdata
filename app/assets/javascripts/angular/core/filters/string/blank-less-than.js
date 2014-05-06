RunEnergy.Dashboard.Filters.filter('reStrBlankLessThan', function () {
    return function (value, min) {
        if (min === undefined) {
            min = 0;
        }
        return _.isNaN(value) || parseFloat(value) < min ? '' : value;
    };
});