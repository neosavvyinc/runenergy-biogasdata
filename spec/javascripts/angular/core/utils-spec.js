describe('RunEnergy.Dashboard.Utils', function () {
    var method;

    describe('NumberUtils', function () {

        describe('isNumber', function () {
            method = RunEnergy.Dashboard.Utils.NumberUtils.isNumber;

            it('Should return true for an integer', function () {
                expect(method(15)).toBeTruthy();
            });

            it('Should return true for a float', function () {
                expect(method(19.1796)).toBeTruthy();
            });

            it('Should return true for a string of a number', function () {
                expect("5446.0").toBeTruthy();
            });

            it('Should return false for NaN', function () {
                expect(method(NaN)).toBeFalsy();
            });

            it('Should return false for a string', function () {
                expect(method("Mike Howard")).toBeFalsy();
            });

            it('Should return false for a stirng number combo', function () {
                expect(method("FIFTY809")).toBeFalsy();
            });

            it('Should return false for null', function () {
                expect(method(null)).toBeFalsy();
            });

            it('Should return false for undefined', function () {
                expect(method(undefined)).toBeFalsy();
            });

            it('Should play nice with negatives', function () {
                expect(method(-80050)).toBeTruthy();
            });

            it('Should play nice with zero', function () {
                expect("00").toBeTruthy();
            });
        });

    });

});