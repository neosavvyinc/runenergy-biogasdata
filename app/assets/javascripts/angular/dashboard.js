var RunEnergy = RunEnergy || {};
RunEnergy.Dashboard = RunEnergy.Dashboard || {};

RunEnergy.Dashboard.Constants = angular.module('runenergy.dashboard.constants', []);
RunEnergy.Dashboard.Services = angular.module('runenergy.dashboard.services', []);
RunEnergy.Dashboard.Controllers = angular.module('runenergy.dashboard.controllers', []);
RunEnergy.Dashboard.Filters = angular.module('runenergy.dashboard.filters', []);
RunEnergy.Dashboard.Directives = angular.module('runenergy.dashboard.directives', []);


angular.module('dashboard', ['runenergy.dashboard.filters', 'runenergy.dashboard.services', 'runenergy.dashboard.directives', 'runenergy.dashboard.constants', 'runenergy.dashboard.controllers']).
    config(['$routeProvider',
        function ($routeProvider) {
            $routeProvider.
                otherwise({templateUrl: 'dashboard'});
        }]).run(['$window', '$templateCache', function ($window, $templateCache) {
        var templates = $window.JST,
            fileName,
            fileContent;

        for (fileName in templates) {
            fileContent = templates[fileName];
            $templateCache.put(fileName, fileContent);
            // Note that we're passing the function fileContent, and not the object
            // returned by its invocation. More on that on Digging Deeper.
        }
    }]);