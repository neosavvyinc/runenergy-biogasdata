describe("reStrBlankLessThan", function () {
    var filter;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            filter = $injector.get('$filter')('reStrBlankLessThan');
        });
    });

    it('Should use 0 as the default limit', function () {
        expect(filter(-1)).toEqual('');
    });

    it('Should return a blank string for an integer less than the limit', function () {
        expect(filter(-12, -11)).toEqual('');
    });

    it('Should return a blank string for a float less than the limit', function () {
        expect(filter(.9999999, 1)).toEqual('');
    });

    it('Should return the number in the case of an equal', function () {
        expect(filter(0)).toEqual(0);
    });

    it('Should return a blank string for a string number less than the limit', function () {
        expect(filter('50.67', '51')).toEqual('');
    });

    it('Should return a blank string for NaN', function () {
        expect(filter(NaN)).toEqual('');
    });

    it('Should return the number in the case that it is greater', function () {
        expect(filter(10, 9)).toEqual(10);
    });

    it('Should return a float in the case that it is greater', function () {
        expect(filter(5.205)).toEqual(5.205);
    });

    it('Should return the string value in the case that its numeric version is greater', function () {
        expect(filter('51.243', '0.1')).toEqual('51.243');
    });

    it('Should be able to take an additional condition to evaluate before evaluating the filter', function () {
        expect(filter('50.67', '51', false)).toEqual('50.67');
    });

    it('Should be able to take an additional condition to evaluate before evaluating the filter', function () {
        expect(filter('50.5', '51', true)).toEqual('');
    });
});