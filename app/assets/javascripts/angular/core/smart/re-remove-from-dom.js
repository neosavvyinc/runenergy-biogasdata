RunEnergy.Dashboard.Directives
    .directive('reRemoveFromDom',
    function () {
        return function (scope, element, attrs) {
            var selector = attrs.reRemoveFromDom;
            if (!selector) {
                throw "You must specify a dom selector for the re-remove-from-dom directive.";
            }
        }
    });