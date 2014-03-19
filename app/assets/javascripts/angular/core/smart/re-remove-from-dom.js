RunEnergy.Dashboard.Directives
    .directive('reRemoveFromDom',
    function () {
        return function (scope, element, attrs) {
            if (!attrs.reRemoveFromDom) {
                throw "You must specify a dom selector for the re-remove-from-dom directive.";
            }

            function _arrayContainsSame(arA, arB) {
                return (_.difference(arA, arB).length === 0 && _.difference(arB, arA).length === 0);
            }

            scope.$on('REMOVE_FROM_DOM', function (e, data) {
                if (data) {
                    var keys = _.keys(data);
                    var values = _.map(data, function (val) {
                        return String(val);
                    });
                    element.find(attrs.reRemoveFromDom).each(function (idx, value) {
                        if (_arrayContainsSame(_.intersection(_.keys(this.dataset), keys), keys) &&
                            _arrayContainsSame(_.intersection(_.values(this.dataset), values), values)) {
                            $(this).remove();
                        }
                    });
                }
            });
        }
    });