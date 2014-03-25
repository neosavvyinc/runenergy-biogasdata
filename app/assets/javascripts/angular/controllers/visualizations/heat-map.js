RunEnergy.Dashboard.Controllers.controller('controllers.visualizations.HeatMap',
    ['$scope',
        '$location',
        function ($scope,
                  $location) {

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

            function _handleData() {
                _load($scope.assetMap, $scope.readingMap);
            }

            var da = $scope.$watch('assetMap', _handleData);
            var db = $scope.$watch('readingMap', _handleData);

        }]);