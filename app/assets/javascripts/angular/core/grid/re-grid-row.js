RunEnergy.Dashboard.Directives
    .directive('reGridRow', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<tr class="re-grid-row row-fluid"><td ng-repeat="subItem in item" ng-bind="subItem"></td></tr>',
            scope: {
                item: "="
            },
            link: function (scope, element, attrs) {

            }
        }
    });
