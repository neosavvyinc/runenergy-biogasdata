RunEnergy.Dashboard.Directives
    .directive('reBootstrapButtonDropdown', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<div class="btn-group"><a class="btn dropdown-toggle" ng-class="innerLinkClass" data-toggle="{{_disabled | nsLogicalIf : \'\' : \'dropdown\'}}">{{(_defaultLabelFunction(selectedItem, labelField) || default)}}<span class="caret"></span></a><ul class="dropdown-menu"><li ng-repeat="item in items" ng-click="onClick(item)"><a ng-bind="_defaultLabelFunction(item, labelField)"></a></li></ul></div>',
            scope: {
                items: "=",
                selectedItem: "=",
                labelFunction: "=",
                labelField: "@",
                default: "@",
                disabled: "@"
            },
            link: function (scope, element, attrs) {
                scope._disabled = false;
                scope.$watch('disabled', function (val) {
                    scope._disabled = (val && (String(val) === '1' || String(val) === 'true'));
                });

                scope.onClick = function (item) {
                    if (!scope._disabled) {
                        scope.selectedItem = item;
                    }
                };

                if (attrs.linkClass) {
                    scope.innerLinkClass = attrs.linkClass;
                }

                scope.$watch('labelFunction', function (val) {
                    if (val && typeof val === 'function') {
                        scope._defaultLabelFunction = val;
                    }
                });

                scope._defaultLabelFunction = function (item, labelField) {
                    return (item && labelField ? item[labelField] : item);
                };
            }
        }
    });