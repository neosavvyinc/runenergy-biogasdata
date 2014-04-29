ddescribe('_re.collection', function () {
    var fn;

    describe('compress', function () {

        beforeEach(function () {
            fn = _re.collection.compress;
        });

        it('Should return undefined when passed', function () {
            expect(fn(undefined)).toBeUndefined();
        });

        it('Should return null when passed', function () {
            expect(fn(null)).toBeNull();
        });

        it('Should return an empty collection when passed', function () {
            expect(fn([])).toEqual([]);
        });

        it('Should return the same collection if there is no min, max, percent, options', function () {
            expect(fn([1, 2, 3, 4])).toEqual([1, 2, 3, 4]);
        });

        it('Should reduce all numbers by the min', function () {
            expect(fn([6, 7, 8], 2)).toEqual([4, 5, 6]);
        });

        it('Should bring numbers lower than the min up to the min', function () {
            expect(fn([-5, -3, -1, 0, 6, 7, 8], 2)).toEqual([2, 2, 2, 2, 4, 5, 6]);
        });

        it('Should limit numbers higher than the max to the max', function () {
            expect(fn([7, 7, 8], undefined, 6)).toEqual([6, 6, 6]);
        });

        it('Should remove nulls, undefined, and NaN', function () {
            expect(fn([-5, undefined, -3, -1, 0, null, 6, 7, NaN, 8], 2)).toEqual([2, 2, 2, 2, 4, 5, 6]);
        });

        it('Should enforce max and min when they are both provided', function () {
            expect(fn([1, 7], 2, 5)).toEqual([2, 5]);
        });

        it('Should make the max the actual max and the min the actual min', function () {
            expect(fn([3, 4], 2, 5)).toEqual([2, 5]);
        });

        it('Should add or subtract from numbers based on where they are from the major trend area', function () {

        });

        it('Should use 50% distribution for the major trend area', function () {

        });

    });

});