describe("reCollectionOrderedProperties", function () {
    var filter;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            filter = $injector.get('$filter')('reCollectionOrderedProperties');
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

    it('Should return the value when passed on ordering', function () {
        expect(filter([
            {id: 1},
            {id: 3},
            {id: 5}
        ])).toEqual([
            {id: 1},
            {id: 3},
            {id: 5}
        ]);
    });

    it('Should be able to order by id by default', function () {
        expect(filter([
            {id: 1},
            {id: 3},
            {id: 5}
        ], '3, 1, 5')).toEqual([
            {id: 3},
            {id: 1},
            {id: 5}
        ]);
    });

    it('Should be able to order by other properties', function () {
        expect(filter([
            {id: 1, name: 'George'},
            {id: 3, name: 'Tim'},
            {id: 5, name: 'Tiny'}
        ], 'Tim, Tiny, George', 'name')).toEqual([
            {id: 3, name: 'Tim'},
            {id: 5, name: 'Tiny'},
            {id: 1, name: 'George'}
        ]);
    });

    it('Should play nice with dot property ordering', function () {
        expect(filter([
            {id: 1, name: {first: 'George'}},
            {id: 3, name: {first: 'Tim'}},
            {id: 5, name: {first: 'Tiny'}}
        ], 'Tim,Tiny,  George', 'name.first')).toEqual([
            {id: 3, name: {first: 'Tim'}},
            {id: 5, name: {first: 'Tiny'}},
            {id: 1, name: {first: 'George'}}
        ]);
    });
});