RunEnergy.Dashboard.Directives
    .directive('reMonitorLimit',
        ['values.NewDataValues',
            function (newDataValues) {
                var mapFromMonitorLimits = memoize(function(monitorLimits) {
                    var mapping = {};
                    if (monitorLimits && monitorLimits.length) {
                        for (var i = 0; i < monitorLimits.length; i++) {
                            mapping[monitorLimits[i].monitor_point.name] = monitorLimits[i];
                        }
                    }
                    return mapping;
                });

                return {
                    require: 'ngModel',
                    link: function (scope, element, attrs, ctrl) {
                        if (!attrs.reMonitorLimit) {
                            throw "You must provide a monitor-limit attribute value as key for validation.";
                        }
                        ctrl.$parsers.unshift(function(viewValue) {
                            if (newDataValues.selectedSite &&
                                newDataValues.selectedSite.monitor_limits &&
                                newDataValues.selectedSite.monitor_limits.length) {
                                var map = mapFromMonitorLimits(newDataValues.selectedSite.monitor_limits);
                                if (parseFloat(viewValue) > parseFloat(map[attrs.reMonitorLimit].upper_limit) ||
                                    parseFloat(viewValue) < parseFloat(map[attrs.reMonitorLimit].lower_limit)) {
                                    ctrl.$setValidity('re-monitor-limit', false);
                                    return undefined
                                }
                            }
                            ctrl.$setValidity('re-monitor-limit', true);
                            return viewValue;
                        });
                    }
                }
            }]);