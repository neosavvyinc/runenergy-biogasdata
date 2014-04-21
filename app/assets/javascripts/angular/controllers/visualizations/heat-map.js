RunEnergy.Dashboard.Controllers.controller('controllers.visualizations.HeatMap',
    ['$scope',
        '$location',
        function ($scope, $location) {

            /* Temporary UI Code */
            function orientToCanvas(dataToOrient) {
                var heatReadings = dataToOrient.heatReadings;
                var labeledPoints = dataToOrient.labeledPoints;

                // sort rows in descending order by y value
                heatReadings.sort(function (a, b) {
                    return b.y - a.y;
                });

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

            var called = false;

            function _load(labeledPoints, heatReadings) {
                if (!called && labeledPoints && labeledPoints.length && heatReadings && heatReadings.length) {
                    called = true;
                    var orientedData = orientToCanvas({
                        heatReadings: heatReadings,
                        labeledPoints: labeledPoints
                    });
                    heatReadings = orientedData.heatReadings;
                    labeledPoints = orientedData.labeledPoints;
                    var element = document.getElementsByClassName('heat-map-area')[0];

                    // heatmap configuration
                    var config = {
                        element: element,
                        radius: 38,
                        opacity: 100,
                        legend: {
                            position: 'br'
                        }
                        /*
                         gradient: {
                         0.125: 'rgb(101,100,254)',
                         0.25: 'rgb(0,57,197)',
                         0.375: 'rgb(0,219,34)',
                         0.5: 'rgb(124,254,0)',
                         0.625: 'rgb(254,236,1)',
                         0.75: 'rgb(255,134,0)',
                         0.875: 'rgb(255,51,1)',
                         1: 'rgb(255,255,255)'
                         } */
                    };


                    var heatmap = h337.create(config);

                    // let's get some data
                    var data = {
                        max: $location.search().max ? parseInt($location.search().max) : 100,
                        data: heatReadings
                    };

                    heatmap.store.setDataSet(data);
                    heatmap.drawLabeledPoints(labeledPoints);

                    da();
                    db();
                }
            }

            function _maxPointValue(collection) {
                var max = 0;
                for (var i = 0; i < collection.length; i++) {
                    var item = collection[i];
                    var x = Math.abs(parseFloat(item.x));
                    var y = Math.abs(parseFloat(item.y));
                    if (x > max) {
                        max = x
                    }
                    if (y > max) {
                        max = y;
                    }
                }
                return max;
            }

            function _minPropValue(collection, prop) {
                var min;
                for (var i = 0; i < collection.length; i++) {
                    var val = Math.abs(parseFloat(collection[i][prop]));
                    if (!min || val < min) {
                        min = val;
                    }
                }
                return min;
            }

            var _confineCollection = memoize(function (collection, minX, minY) {
                if (collection && collection.length) {
                    return _.filter(_.map(collection, function (item) {
                        item.x = parseInt((parseFloat(item.x) - minX));
                        item.y = parseInt((parseFloat(item.y) - minY));
                        return item;
                    }), function (item) {
                        return item && item.x && item.y && item.x != NaN && item.y != NaN;
                    });
                }
                return collection;
            });

            function _handleData() {
                if ($scope.assetMap && $scope.readingMap && $scope.assetMap.length && $scope.readingMap.length) {
                    var minX = _minPropValue($scope.assetMap.concat($scope.readingMap), 'x');
                    var minY = _minPropValue($scope.assetMap.concat($scope.readingMap), 'y');
                    _load(_confineCollection($scope.assetMap, minX, minY), _confineCollection($scope.readingMap, minX, minY));
                }
            }

            var da = $scope.$watch('assetMap', _handleData);
            var db = $scope.$watch('readingMap', _handleData);

        }]);