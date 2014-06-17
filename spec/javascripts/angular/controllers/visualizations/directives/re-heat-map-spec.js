describe("reHeatMapUtils", function () {
    var factory, $location, $window;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat({
            $location: jasmine.createSpyObj('$location', ['search']),
            $window: {location: {}}
        }));

        inject(function ($injector) {
            factory = $injector.get('reHeatMapUtils');
            $location = $injector.get('$location');
            $window = $injector.get('$window');
            $location.search.andReturn({});
        });
    });

    describe('sanitizeReadings', function () {
        it('Should filter out null and undefined values', function () {
            expect(factory.sanitizeReadings([undefined, {count: 11, x: 17, y: 18}, null])).toEqual([
                {count: 11, x: 17, y: 18}
            ]);
        });

        it('Should filter out null, undefined x values', function () {
            expect(factory.sanitizeReadings([
                {count: 11, x: null, y: 396},
                {count: 11, x: 17, y: 18},
                {count: 11, x: undefined, y: 376}
            ])).toEqual([
                    {count: 11, x: 17, y: 18}
                ]);
        });

        it('Should filter out null, undefined y values', function () {
            expect(factory.sanitizeReadings([
                {count: 11, y: null, x: 396},
                {count: 11, x: 17, y: 18},
                {count: 11, y: undefined, x: 376}
            ])).toEqual([
                    {count: 11, x: 17, y: 18}
                ]);
        });

        it('Should not filter out 0 values for x', function () {
            expect(factory.sanitizeReadings([
                {count: 11, x: null, y: 396},
                {count: 11, x: 17, y: 18},
                {count: 11, x: 0, y: 376}
            ])).toEqual([
                    {count: 11, x: 17, y: 18},
                    {count: 11, x: 0, y: 376}
                ]);
        });

        it('Should not filter out 0 values for y', function () {
            expect(factory.sanitizeReadings([
                {count: 11, y: 0, x: 396},
                {count: 11, x: 17, y: 18},
                {count: 11, y: undefined, x: 376}
            ])).toEqual([
                    {count: 11, y: 0, x: 396},
                    {count: 11, x: 17, y: 18}
                ]);
        });

        it('Should filter out undefined, null values for count', function () {
            expect(factory.sanitizeReadings([
                {count: null, y: 0, x: 396},
                {count: undefined, x: 17, y: 18},
                {count: 11, y: undefined, x: 376}
            ])).toEqual([
                ]);
        });

        it('Should not filter out zeroes for count', function () {
            expect(factory.sanitizeReadings([
                {count: 0, y: 0, x: 396},
                {count: 11, x: 17, y: 18},
                {count: 11, y: undefined, x: 376}
            ])).toEqual([
                    {count: 0, y: 0, x: 396},
                    {count: 11, x: 17, y: 18}
                ]);
        });

        it('Should convert x to positive integers', function () {
            expect(factory.sanitizeReadings([
                {count: 11, y: 0, x: "396.5050"},
                {count: 11, x: 17.756, y: 18},
                {count: 11, y: 12, x: -376}
            ])).toEqual([
                    {count: 11, y: 0, x: 396},
                    {count: 11, x: 17, y: 18},
                    {count: 11, y: 12, x: 376}
                ]);
        });

        it('Should convert y to positive integers', function () {
            expect(factory.sanitizeReadings([
                {count: 11, y: 0, x: "396.5050"},
                {count: 11, x: 17.756, y: -18},
                {count: 11, y: "-12.00001", x: -376}
            ])).toEqual([
                    {count: 11, y: 0, x: 396},
                    {count: 11, x: 17, y: 18},
                    {count: 11, y: 12, x: 376}
                ]);
        });

        it('Should convert count to an integer', function () {
            expect(factory.sanitizeReadings([
                {count: 11.67, y: 0, x: "396.5050"},
                {count: "11", x: 17.756, y: -18},
                {count: -11, y: "-12.00001", x: -376}
            ])).toEqual([
                    {count: 11, y: 0, x: 396},
                    {count: 11, x: 17, y: 18},
                    {count: -11, y: 12, x: 376}
                ]);
        });
    });

    describe('sanitizeLabeledPoints', function () {
        it('Should filter out null and undefined values', function () {
            expect(factory.sanitizeLabeledPoints([undefined, {label: 'Tim', x: 17, y: 18}, null])).toEqual([
                {label: 'Tim', x: 17, y: 18}
            ]);
        });

        it('Should filter out null, undefined x values', function () {
            expect(factory.sanitizeLabeledPoints([
                {label: 'Tim', x: null, y: 396},
                {label: 'Tim', x: 17, y: 18},
                {label: 'Tim', x: undefined, y: 376}
            ])).toEqual([
                    {label: 'Tim', x: 17, y: 18}
                ]);
        });

        it('Should filter out null, undefined y values', function () {
            expect(factory.sanitizeLabeledPoints([
                {label: 'Tim', y: null, x: 396},
                {label: 'Tim', x: 17, y: 18},
                {label: 'Tim', y: undefined, x: 376}
            ])).toEqual([
                    {label: 'Tim', x: 17, y: 18}
                ]);
        });

        it('Should not filter out 0 values for x', function () {
            expect(factory.sanitizeLabeledPoints([
                {label: 'Tim', x: null, y: 396},
                {label: 'Tim', x: 17, y: 18},
                {label: 'Tim', x: 0, y: 376}
            ])).toEqual([
                    {label: 'Tim', x: 17, y: 18},
                    {label: 'Tim', x: 0, y: 376}
                ]);
        });

        it('Should not filter out 0 values for y', function () {
            expect(factory.sanitizeLabeledPoints([
                {label: 'Tim', y: 0, x: 396},
                {label: 'Tim', x: 17, y: 18},
                {label: 'Tim', y: undefined, x: 376}
            ])).toEqual([
                    {label: 'Tim', y: 0, x: 396},
                    {label: 'Tim', x: 17, y: 18}
                ]);
        });

        it('Should not filter out undefined null label values, convert them to blank strings', function () {
            expect(factory.sanitizeLabeledPoints([
                {y: 0, x: 396},
                {label: null, x: 17, y: 18},
                {label: 'Tim', y: undefined, x: 376}
            ])).toEqual([
                    {label: '', y: 0, x: 396},
                    {label: '', x: 17, y: 18}
                ]);
        });

        it('Should convert x to positive integers', function () {
            expect(factory.sanitizeLabeledPoints([
                {label: 'Tim', y: 0, x: "396.5050"},
                {label: 'Tim', x: 17.756, y: 18},
                {label: 'Tim', y: 12, x: -376}
            ]).valueOf()).toEqual([
                    {label: 'Tim', y: 0, x: 396},
                    {label: 'Tim', x: 17, y: 18},
                    {label: 'Tim', y: 12, x: 376}
                ]);
        });

        it('Should convert y to positive integers', function () {
            expect(factory.sanitizeLabeledPoints([
                {label: 'Tim', y: 0, x: "396.5050"},
                {label: 'Tim', x: 17.756, y: -18},
                {label: 'Tim', y: "-12.00001", x: -376}
            ])).toEqual([
                    {label: 'Tim', y: 0, x: 396},
                    {label: 'Tim', x: 17, y: 18},
                    {label: 'Tim', y: 12, x: 376}
                ]);

        });

    });

    describe('applyFloor', function () {

        it('Should subtract the min version of the prop from all the other nodes with the prop', function () {
            expect(factory.applyFloor([
                {x: 16},
                {x: 20},
                {x: 67}
            ], 'x')).toEqual([
                    {x: 0},
                    {x: 4},
                    {x: 51}
                ]);
        });

        it('Should be able to add the base to the value for everyone except the min', function () {
            expect(factory.applyFloor([
                {x: 16},
                {x: 20},
                {x: 67}
            ], 'x', 2)).toEqual([
                    {x: 2},
                    {x: 6},
                    {x: 53}
                ]);
        });

        it('Should default the base to 0', function () {
            expect(factory.applyFloor([
                {x: 16},
                {x: 20},
                {x: 67}
            ], 'x')).toEqual(factory.applyFloor([
                    {x: 16},
                    {x: 20},
                    {x: 67}
                ], 'x', 0));
        });
    });

    describe('max', function () {
        it('Should return the $window.location.search param if it is defined', function () {
            $window.location.search = '?max=890&something=blue';
            expect(factory.max()).toEqual('890');
        });

        it('Should return 2000 if the max is not defined', function () {
            expect(factory.max()).toEqual(2000);
        });
    });

    describe('min', function () {
        it('Should return the $window.location.search param if it is defined', function () {
            $window.location.search = '?min=-29&something=blue';
            expect(factory.min()).toEqual('-29');
        });

        it('Should return 0 if the min is not defined', function () {
            expect(factory.min()).toEqual(0);
        });
    });
});