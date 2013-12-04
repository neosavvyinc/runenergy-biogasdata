RunEnergy.Dashboard.Directives
    .directive('reBootstrapButtonDropdown', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<div class="btn-group"><a class="btn dropdown-toggle" ng-class="innerLinkClass" data-toggle="dropdown">{{labelField && selectedItem[labelField] | logicalIif : selectedItem[labelField] : (selectedItem || default)}}<span class="caret"></span></a><ul class="dropdown-menu"><li ng-repeat="item in items" ng-click="onClick(item)"><a ng-bind="labelField && item[labelField] | logicalIif : item[labelField] : item"></a></li></ul></div>',
            scope: {
                items: "=",
                selectedItem: "=",
                labelField: "@",
                default: "@"
            },
            link: function (scope, element, attrs) {
                scope.onClick = function (item) {
                    scope.selectedItem = item;
                };

                if (attrs.linkClass) {
                    scope.innerLinkClass = attrs.linkClass;
                }
            }
        }
    });