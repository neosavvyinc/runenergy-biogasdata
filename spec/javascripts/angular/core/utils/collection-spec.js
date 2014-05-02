xdescribe('_re.collection', function () {
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