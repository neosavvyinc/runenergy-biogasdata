RunEnergy.Dashboard.Directives
    .directive('reDisabled', function () {
        return {
            restrict: 'A',
            scope: false,
            link: function (scope, element, attrs) {
                if (attrs.reDisabled) {
                    scope.$watch(attrs.reDisabled, function (newValue) {
                        var inputs = [element[0]].concat(element[0].getElementsByTagName('input'));
                        for (var i = 0; i < inputs.length; i++) {
                            if (newValue) {
                                element[0].setAttribute("disabled", true);
                                if (!$(element).hasClass('disabled')) {
                                    $(element).addClass('disabled');
                                }
                            } else {
                                element[0].removeAttribute("disabled");
                                $(element).removeClass('disabled');
                            }
                        }
                    });
                } else {
                    throw "You must provide a disabled attribute in order to add a disabled state to this control.";
                }
            }
        }
    });