RunEnergy.Dashboard.Directives
    .factory('reHeatMapUtils', function () {
        /* Imports */
        var _isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

        function _sharedSanitize(val) {
            return _(val).compact()
                .filter(function (node) {
                    return !_isBlank(node.x) && !_isBlank(node.y);
                }).map(function (node) {
                    node.x = Math.abs(parseInt(node.x));
                    node.y = Math.abs(parseInt(node.y));
                    return node;
                });
        }

        /* These can all be made to work a bit more efficiently */
        return {
            sanitizeReadings: function (val) {
                return _sharedSanitize(val)
                    .filter(function (node) {
                        return !_isBlank(node.count);
                    }).map(function (node) {
                        node.count = parseInt(node.count);
                        return node;
                    }).valueOf();
            },
            sanitizeLabeledPoints: function (val) {
                return _sharedSanitize(val)
                    .map(function (node) {
                        node.label = node.label || '';
                        return node;
                    }).valueOf();
            },
            applyFloor: function (val, prop, base) {
                base = base || 0;
                var minProp;
                for (var i = 0; i < val.length; i++) {
                    if (_.isUndefined(minProp) || val[i][prop] < minProp) {
                        minProp = val[i][prop];
                    }
                }
                return _.map(val, function (node) {
                    node[prop] = (node[prop] - minProp) + base;
                    return node;
                })
            }
        };
    });

RunEnergy.Dashboard.Directives
    .directive('reHeatMap', ['reHeatMapUtils',
        function (reHeatMapUtils) {
            var _hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;

            /* Orienting Function */
            function orientToCanvas(dataToOrient) {
                var heatReadings = reHeatMapUtils.applyFloor(reHeatMapUtils.applyFloor(reHeatMapUtils.sanitizeReadings(dataToOrient.heatReadings), 'x', -500000), 'y');
                var labeledPoints = reHeatMapUtils.applyFloor(reHeatMapUtils.applyFloor(reHeatMapUtils.sanitizeLabeledPoints(dataToOrient.labeledPoints), 'x', -500000), 'y');

                /* Existing interface starts here */
                // sort rows in descending order by y value
                heatReadings.sort(function (a, b) {
                    return b.y - a.y;
                });

                /* Height Changes */
                var MAXHEIGHT = heatReadings[0].y;
                var MARGIN_LEFT = -800;
                var MARGIN_TOP = 50;

                heatReadings = heatReadings.map(function (reading) {
                    return {
                        count: reading.count,
                        x: reading.x + MARGIN_LEFT,
                        y: -reading.y + MAXHEIGHT + MARGIN_TOP
                    };
                });

                labeledPoints = labeledPoints.map(function (point) {
                    return {
                        label: point.label,
                        x: point.x + MARGIN_LEFT,
                        y: -point.y + MAXHEIGHT + MARGIN_TOP
                    };
                });

                return {
                    heatReadings: heatReadings,
                    labeledPoints: labeledPoints
                };
            };

            /* Directive Definition */
            return {
                restrict: 'A',
                scope: {
                    heatReadings: '=',
                    labeledPoints: '='
                },
                link: function (scope, element, attrs) {

                    function _load() {
                        if (_hpGet(scope.heatReadings, 'length') &&
                            _hpGet(scope.labeledPoints, 'length')) {

                            var orientedData = orientToCanvas({
                                heatReadings: scope.heatReadings,
                                labeledPoints: scope.labeledPoints
                            });
                            var heatReadings = orientedData.heatReadings;
                            var labeledPoints = orientedData.labeledPoints;

                            // heatmap configuration
                            var config = {
                                element: element[0],
                                radius: 38,
                                opacity: 100,
                                legend: {
                                    position: 'br'
                                }
                            };


                            var heatmap = h337.create(config);

                            // let's get some data
                            var data = {
                                max: attrs.max || 535498,
                                data: heatReadings
                            };

                            heatmap.store.setDataSet(data);
                            heatmap.drawLabeledPoints(labeledPoints);

                            da();
                            db();
                        }
                    }

                    var da = scope.$watch('heatReadings', _load, true);
                    var db = scope.$watch('labeledPoints', _load, true);
                }
            }
        }]);