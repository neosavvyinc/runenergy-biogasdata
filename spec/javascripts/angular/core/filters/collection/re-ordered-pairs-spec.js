describe("reCollectionOrderedPairs", function () {
    var filter;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            filter = $injector.get('$filter')('reCollectionOrderedPairs');
        });
    });

    it('Should return undefined when it is passed', function () {
        expect(filter(undefined)).toBeUndefined();
    });

    it('Should return null when it is passed', function () {
        expect(filter(null)).toBeNull();
    });

    it('Should return a blank array when passed an object', function () {
        expect(filter({})).toEqual([]);
    });

    it('Should convert an object to pairs even when not provided an ordering', function () {
        expect(filter({name: "Charles", age: 17, hair: "Long"})).toEqual([
            ["name", "Charles"],
            ["age", 17],
            ["hair", "Long"]
        ]);
    });

    it('Should know how to order based on the key string it is passed', function () {
        expect(filter({name: "Charles", age: 17, hair: "Long"}, 'hair, age, name')).toEqual([
            ["hair", "Long"],
            ["age", 17],
            ["name", "Charles"]
        ]);
    });

    it('Should not care about spaces with the comments in the ordering string', function () {
        expect(filter({name: "Charles", age: 17, hair: "Long"}, 'hair,age ,    name')).toEqual([
            ["hair", "Long"],
            ["age", 17],
            ["name", "Charles"]
        ]);
    });

    it('Should not worry about extra params in the ordering string', function () {
        expect(filter({name: "Charles", age: 17, hair: "Long"}, ' age, hair, weight, name, methane')).toEqual([
            ["age", 17],
            ["hair", "Long"],
            ["name", "Charles"]
        ]);
    });

    it('Should be case insensitive with the ordering params', function () {
        expect(filter({name: "Charles", age: 17, hair: "Long"}, 'AGE, HAIR,  NAME')).toEqual([
            ["age", 17],
            ["hair", "Long"],
            ["name", "Charles"]
        ]);
    });
});