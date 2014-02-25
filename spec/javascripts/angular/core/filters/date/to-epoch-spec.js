describe("reDateToEpoch", function () {
    var filter;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            filter = $injector.get('$filter')('reDateToEpoch');
        });
    });

    it('Should return undefined when passed', function () {
        expect(filter(undefined)).toBeUndefined();
    });

    it('Should return null when passed', function () {
        expect(filter(null)).toBeNull();
    });

    it('Should return a blank string if passed', function () {
        expect(filter("")).toEqual("");
    });

    it('Should return the getTime method divided by 100', function () {
        var dateSpy = jasmine.createSpyObj('Date', ['getTime']);
        dateSpy.getTime.andReturn(5000);
        expect(filter(dateSpy)).toEqual(5);
    });
});