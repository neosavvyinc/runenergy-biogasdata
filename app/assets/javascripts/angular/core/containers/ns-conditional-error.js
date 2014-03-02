(function (window, angular) {
    /* Imports */
    var _isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

    RunEnergy.Dashboard.Directives.value('nsConditionErrors', {
        error: ""
    });

    RunEnergy.Dashboard.Directives.service('nsConditions',
        ['nsConditionErrors',
            function (nsConditionErrors) {
                var _errors = [];
                var _value = true;
                var _stoppedIndex = -1;

                function _wrap(fn) {
                    return function () {
                        if (_value) {
                            _value = fn.apply(fn, arguments);
                            if (_stoppedIndex !== -1) {
                                _setError(_stoppedIndex);
                            }
                        }
                        return this;
                    }
                }

                function _setError(idx) {
                    if (_errors && _errors.length) {
                        nsConditionErrors.error = _errors[Math.min(idx, _errors.length - 1)];
                    }
                }

                this.errors = function () {
                    _errors = arguments;
                    return this;
                };

                this.valueOf = function () {
                    if (_value) {
                       nsConditionErrors.error = "";
                    }
                    /* Set back to true for next evaulation */
                    var valueOfValue =_value;
                    _value = true;

                    return valueOfValue;
                };

                /* Conditional Methods */
                this.anyBlank = function () {
                    for (var i = 0; i < arguments.length; i++) {
                        if (_isBlank(arguments[i])) {
                            _stoppedIndex = i;
                            return true;
                        }
                    }
                    return false;
                };

                this.execute = function () {
                    if (arguments.length % 2 === 0) {
                        if (arguments.length) {
                            for (var i = 0; i < arguments.length; i += 2) {
                                if (typeof arguments[i] === 'function') {
                                    if (!arguments[i].apply(arguments[i], arguments[i + 1])) {
                                        _stoppedIndex = i / 2;
                                        return false;
                                    }
                                }
                            }
                        }
                        return true;
                    } else {
                        throw "Execute requires an even number of arguments, (fn, [arguments, ...], ...)";
                    }
                };

                /* Inverse 'not' Methods */
                for (var fn in this) {
                    if (typeof this[fn] === 'function' && fn !== 'errors' && fn !== 'valueOf') {
                        this["not" + fn.charAt(0).toUpperCase() + fn.slice(1)] = (function (original) {
                            return _wrap(function () {
                                return !original.apply(this, arguments);
                            })
                        })(this[fn]);

                        /* Wrap Functions, After Nots Are Created */
                        this[fn] = _wrap(this[fn]);
                    }
                }
            }]);

    RunEnergy.Dashboard.Directives
        .directive('nsConditionalError',
            ['nsConditionErrors',
                function (nsConditionsErrors) {
                    return {
                        restrict: 'E',
                        template: '<label class="error" ng-bind="error"></label>',
                        scope: {
                            error: "="
                        },
                        link: function (scope, element, attrs) {
                            scope.nsConditionsErrors = nsConditionsErrors;
                            scope.$watch('nsConditionsErrors.error', function (val) {
                                scope.error = val;
                            });
                        }
                    }
                }]);

})(window, angular)

