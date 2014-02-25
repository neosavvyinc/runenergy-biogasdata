RunEnergy.Dashboard.Filters.filter('reDateToEpoch', function () {
    return function (dateTime) {
        if (dateTime) {
            return parseInt(dateTime.getTime() / 1000)
        }
        return dateTime;
    };
});