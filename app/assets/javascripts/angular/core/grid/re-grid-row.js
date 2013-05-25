RunEnergy.Dashboard.Directives
    .directive('reGridRow', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<div><span ng-repeat="subItem in item" ng-bind="subItem"></span></div>',
            scope: {
                item: "="
            },
            link: function (scope, element, attrs) {

            }
        }
    });
