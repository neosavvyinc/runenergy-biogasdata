describe('RunEnergy.Dashboard.Filters', function () {
    var filter, $filter;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            $filter = $injector.get('$filter');
        });
    });

    describe('numericExpression', function () {
        beforeEach(function () {
            inject(function ($injector) {
                filter = $filter('numericExpression');
            });
        });

        it('Should return an empty array when no data is passed', function () {
            expect(filter()).toEqual([]);
        });

        it('Should return an empty array if no expressions to properties are passed', function () {
            expect(filter([25, 67, 34])).toEqual([25, 67, 34]);
        });

        it('Should be able to filter by an arbitrary expression on a field', function () {
            var data = [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 0]
            ];
            var expressionsAndIndexes = [{expression: "", index: 2}];
            expect(filter(data, expressionsAndIndexes)).toEqual([
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 0]
            ]);
        });

        it('Should return the original collection when the expression is blank', function () {
            var data = [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 0]
            ];
            var expressionsAndIndexes = [{expression: ">6", index: 1}];
            expect(filter(data, expressionsAndIndexes)).toEqual([[7, 8, 0]]);
        });

        it('Should play nice with multiple expressions', function () {
            var data = [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 0]
            ];
            var expressionsAndIndexes = [{expression: ">3", index: 1}, {expression: "<6", index: 0}];
            expect(filter(data, expressionsAndIndexes)).toEqual([[4, 5, 6]]);
        });

        it('Should return empty when an expression is mal-formed', function () {
            var data = [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 0]
            ];
            var expressionsAndIndexes = [{expression: ">$3", index: 1}, {expression: "<6", index: 0}];
            expect(filter(data, expressionsAndIndexes)).toEqual([]);
        });
    });

    describe('numericFilterRound', function () {
        beforeEach(function () {
            inject(function ($injector) {
                filter = $filter('numericFilterRound');
            });
        });

        it('Should play nice with 0 significant digits', function () {
            expect(filter(24, 0)).toEqual("24");
            expect(filter("256.009", 0)).toEqual("256");
            expect(filter(25.1, 0)).toEqual("25");
        });

        it('Should append a zero the front of a decimal number', function () {
            expect(filter(101.675, 1)).toEqual("101.7");
        });

        it('Should round to the significant digits', function () {
            expect(filter(.009876, 4)).toEqual("0.0099");
        });

        it('Should add a zero for two significant digit decimals', function () {
            expect(filter(.234, 2)).toEqual("0.23");
        });

        it('Should play nice with negative numbers', function () {
            expect(filter(-20.92, 0)).toEqual("-21");
        });

        it('Should play nice with negative decimal numbers', function () {
            expect(filter(-678.98354, 3)).toEqual("-678.984");
        });

        it('Should play nice with negative decimal numbers less than absolute value of 1', function () {
            expect(filter(-0.378, 1)).toEqual("-0.4");
            expect(filter(-0.390, 4)).toEqual("-0.3900");
        });
    });

    describe('nsTextProperToSnake', function () {
        beforeEach(function () {
            inject(function ($injector) {
                filter = $filter('nsTextProperToSnake');
            });
        });

        it('Should return undefined if passed undefined', function () {
            expect(filter(undefined)).toBeUndefined();
        });

        it('Should return a blank string when passed a blank string', function () {
            expect(filter("")).toEqual("");
        });

        it('Should return null when passed null', function () {
            expect(filter(null)).toBeNull();
        });

        it('Should play nice with lowercase strings', function () {
            expect(filter("something i learned today")).toEqual("something_i_learned_today");
        });

        it('Should play nice with camelcase strings', function () {
            expect(filter("SomethingILearned Today")).toEqual("somethingilearned_today");
        });

        it('Should play nice with multi white spaces', function () {
            expect(filter("Something  I  Learned Today")).toEqual("something_i_learned_today");
        });

        it('Should play nice with uppercase strings', function () {
            expect(filter("SOMETHINGNEW  FOOOLS 50")).toEqual("somethingnew_foools_50");
        });
    });
});