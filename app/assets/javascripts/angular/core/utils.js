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

RunEnergy.Dashboard.Utils.DomUtils = (function () {
    return {
        getElementsByAttribute: function (tagName, attr, value) {
            var matchingElements = [];
            var allElements = document.getElementsByTagName(tagName);
            for (var i = 0; i < allElements.length; i++) {
                if (allElements[i].getAttribute(attr) == value) {
                    // Element exists with attribute. Add to array.
                    matchingElements.push(allElements[i]);
                }
            }
            return matchingElements;
        }
    };
})();
