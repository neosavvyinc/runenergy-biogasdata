var RunEnergy = RunEnergy || {};
RunEnergy.Dashboard = RunEnergy.Dashboard || {};
RunEnergy.Dashboard.Directives = angular.module('runenergy.dashboard.directives', []);

RunEnergy.Dashboard.Directives
    .controller('HeatMapCtrl',
        ['$scope', function ($scope) {

            /* Initialization */
            $scope.heatReadings = [];
            $scope.labeledPoints = [];

            /* Heat Readings CSV */
            d3.csv("/SITA_readings.csv", function (d) {
                return {
                    x: Math.floor(+d.x),
                    y: Math.floor(+d.y),
                    count: Math.floor(+d.count)
                };
            }, function (error, heatReadings) {
                $scope.$apply(function () {
                    $scope.heatReadings = heatReadings;
                });
            });

            /* Labeled Points CSV */
            d3.csv("/SITA_post.csv", function (d) {
                return {
                    x: Math.floor(+d.x),
                    y: Math.floor(+d.y),
                    label: d.id
                };
            }, function (error, labeledPoints) {
                $scope.$apply(function () {
                    $scope.labeledPoints = labeledPoints;
                });
            });
        }]);

RunEnergy.Dashboard.Directives
    .directive('reHeatMap',
    function () {
        var _hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;

        /* Orienting Function */
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
                            max: 80,
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
    });