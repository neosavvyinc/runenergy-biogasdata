RunEnergy.Dashboard.Directives
    .directive('reShowWhenReady',
    function ($compile) {
        return {
            priority: -100,
            restrict: 'AC',
            link: function (scope, element, attrs) {
                var style = element.attr("style");
                var re = /display:\s*none;|display:none;/g;
                if (re.test(style)) {
                    element.attr("style", style.replace(re, ""));
                }
            }
        }
    });