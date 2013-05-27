RunEnergy.Dashboard.Directives
    .directive('reSpinningOverlay',
        ['$timeout',
            function ($timeout) {
                return {
                    restrict: 'A',
                    scope: false,
                    link: function (scope, element, attrs) {
                        var opts = {
                            lines: 10, // The number of lines to draw
                            length: parseInt(attrs.reSpinningOverlayLength) || 55, // The length of each line
                            width: 3, // The line thickness
                            radius: 10, // The radius of the inner circle
                            color: '#292929', // #rbg or #rrggbb
                            speed: 1, // Rounds per second
                            trail: 100, // Afterglow percentage
                            shadow: true // Whether to render a shadow
                        };
                        var spinner;

                        //WATCHERS
                        scope.$watch(attrs.reSpinningOverlay, function (newValue) {
                            if (newValue) {
                                spinner = new Spinner(opts).spin(element[0]);
                            } else if (spinner) {
                                spinner.stop();
                                spinner = null;
                            }
                        });
                    }
                }
            }]);