RunEnergy.Dashboard.Directives
    .directive('reGrid', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<div class="span12"><table><re-grid-row ng-repeat="item in data" data-item="item"></re-grid-row></table></div>',
            scope: {
                data: "="
            },
            link: function (scope, element, attrs) {

            }
        }
    });
