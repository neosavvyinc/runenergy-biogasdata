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

RunEnergy.Dashboard.Utils.RequestUrlUtils = (function () {

    return {
        withParams: function (url, map) {
            if (url && map) {
                for (var key in map) {
                    if (url.indexOf("?") === -1) {
                        url += "?";
                    }
                    url += key + "=" + map[key] + "&";
                }
                return url.indexOf("&") ? url.slice(0, url.length - 1) : url;
            }
            return url;
        }
    }
})();

RunEnergy.Dashboard.Utils.NumberUtils = (function () {
    return {
        isNumber: function isNumber(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        }
    }
})();
