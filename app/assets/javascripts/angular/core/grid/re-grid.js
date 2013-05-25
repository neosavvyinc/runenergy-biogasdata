RunEnergy.Dashboard.Directives
    .directive('reGrid', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<table class="table table-striped"><thead>This is the header</thead><tbody><re-grid-row ng-repeat="item in data" data-item="item"/></tbody></table>',
            scope: {
                data: "="
            },
            link: function (scope, element, attrs) {

            }
        }
    });
