var Neosavvy = Neosavvy || {};

Neosavvy.ApiDoc = Neosavvy.ApiDoc || {};
Neosavvy.ApiDoc.Directives = angular.module('neosavvy.apidoc.directives', []);
Neosavvy.ApiDoc.Dependencies = ['neosavvy.apidoc.directives'];

var result = document.createElement('div');
Neosavvy.ApiDoc.Directives.directive('nsApiDoc', function ($http) {
    return {
        restrict: 'E',
        template: '<div ng-transclude></div>',
        transclude: true,
        scope: {
            endpoint: '='
        },
        link: function (scope, elem, attrs) {

            scope.path = scope.endpoint.path;
            scope.method = scope.endpoint.method;
            scope.params = scope.endpoint.params;
            scope.payload = scope.endpoint.payload ? JSON.stringify(scope.endpoint.payload, undefined, 4) : {};

            scope.response = {};
            scope.errors = undefined;

            scope.status = 'ok';

            $http({method: scope.method, url: scope.path, data: scope.payload}).then(function (resp) {
                scope.response = JSON.stringify(resp.data, undefined, 4);
                
                return resp.data;
            });
        }
    }
});

// database state management?
//
// what happens for API responses that may not be the same every time (i.e.
// a date, or timestamp, etc.). Need to find a way to opt-out of checking
// certain API values
//

