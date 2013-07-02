RunEnergy.Dashboard.Directives
    .directive('reSpinningOverlay',
        ['$timeout', '$window',
            function ($timeout, $window) {
                return {
                    restrict: 'A',
                    scope: false,
                    link: function (scope, element, attrs) {
                        var radius = attrs.reSpinnerRadius ? parseFloat(attrs.reSpinnerRadius) : null;
                        var width = attrs.reSpinnerWidth ? parseFloat(attrs.reSpinnerWidth) : null;
                        var lines = attrs.reSpinnerLines ? parseFloat(attrs.reSpinnerLines) : null;
                        var trail = attrs.reSpinnerTrail ? parseFloat(attrs.reSpinnerTrail) : null;
                        var sizeToWindow = attrs.reSpinnerSizeToWindow ? attrs.reSpinnerSizeToWindow !== 'false' : true;
                        var opts = {
                            lines: lines || 10, // The number of lines to draw
                            length: parseInt(attrs.reSpinningOverlayLength) || 55, // The length of each line
                            width: width || 3, // The line thickness
                            radius: radius || 10, // The radius of the inner circle
                            color: '#292929', // #rbg or #rrggbb
                            speed: 1, // Rounds per second
                            trail: trail || 100, // Afterglow percentage
                            shadow: (attrs.reSpinnerShadow ? attrs.reSpinnerShadow !== 'false' : true) // Whether to render a shadow
                        };
                        var spinner;

                        //WATCHERS
                        scope.$watch(attrs.reSpinningOverlay, function (newValue) {
                            if (newValue) {
                                spinner = new Spinner(opts).spin(element[0]);
                                if (sizeToWindow) {
                                    $(spinner.el).css('top', String($($window).height() / 2) + "px");
                                }
                            } else if (spinner) {
                                spinner.stop();
                                spinner = null;
                            }
                        });
                    }
                }
            }]);