var RunEnergy = RunEnergy || {};
RunEnergy.Dashboard = RunEnergy.Dashboard || {};

RunEnergy.Dashboard.Constants = angular.module('runenergy.dashboard.constants', []);
RunEnergy.Dashboard.Services = angular.module('runenergy.dashboard.services', []);
RunEnergy.Dashboard.Managers = angular.module('runenergy.dashboard.managers', []);
RunEnergy.Dashboard.Controllers = angular.module('runenergy.dashboard.controllers', []);
RunEnergy.Dashboard.Filters = angular.module('runenergy.dashboard.filters', []);
RunEnergy.Dashboard.Directives = angular.module('runenergy.dashboard.directives', []);
RunEnergy.Dashboard.Values = angular.module('runenergy.dashboard.values', []);

//Window method for loading haml assets
var haml = new function () {
    var methods = [];
    this.onLoad = function (method) {
        methods.push(method);
    };
    this.load = function () {
        if (methods && methods.length) {
            for (var i = 0; i < methods.length; i++) {
                methods[i]();
            }
        }
    };
}();

RunEnergy.Dashboard.Dependencies = ['runenergy.dashboard.filters', 'runenergy.dashboard.services', 'runenergy.dashboard.managers', 'runenergy.dashboard.directives', 'runenergy.dashboard.constants', 'runenergy.dashboard.controllers', 'runenergy.dashboard.values'];

angular.module('dashboard', RunEnergy.Dashboard.Dependencies).
    config(['$routeProvider',
        function ($routeProvider) {
            $routeProvider.
                otherwise({templateUrl: 'dashboard'});
        }]).run(['$window', '$templateCache', '$http', function ($window, $templateCache, $http) {
        RunEnergy.Dashboard.CSRF_TOKEN = RunEnergy.Dashboard.Utils.DomUtils.getElementsByAttribute("meta", "name", "csrf-token")[0].content;
        $http.defaults.headers.post["X-CSRF-Token"] = RunEnergy.Dashboard.CSRF_TOKEN;
        $http.defaults.headers.put["X-CSRF-Token"] = RunEnergy.Dashboard.CSRF_TOKEN;

        var templates = $window.JST,
            fileName,
            fileContent;

        for (fileName in templates) {
            fileContent = templates[fileName];
            $templateCache.put(fileName, fileContent);
            // Note that we're passing the function fileContent, and not the object
            // returned by its invocation. More on that on Digging Deeper.
        }

        window.haml.load();
    }]);