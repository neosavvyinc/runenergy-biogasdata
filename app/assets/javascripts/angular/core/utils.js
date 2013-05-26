var RunEnergy = RunEnergy || {};
RunEnergy.Dashboard = RunEnergy.Dashboard || {};
RunEnergy.Dashboard.Utils = RunEnergy.Dashboard.Utils || {};

RunEnergy.Dashboard.Utils.MapUtils = (function () {
    return {
        get: function (map, properties) {
            if (map && properties) {
                properties = properties.split(".");
                while (properties.length) {
                    if (map) {
                        map = map[properties.shift()];
                    } else {
                        break;
                    }
                }
            }
            return map;
        }
    }
})();
