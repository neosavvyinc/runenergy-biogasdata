var RunEnergy = RunEnergy || {};
RunEnergy.Dashboard = RunEnergy.Dashboard || {};
RunEnergy.Dashboard.Utils = RunEnergy.Dashboard.Utils || {};

RunEnergy.Dashboard.Utils.NumberUtils = (function () {
    return {
        isNumber: function isNumber(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        }
    }
})();
