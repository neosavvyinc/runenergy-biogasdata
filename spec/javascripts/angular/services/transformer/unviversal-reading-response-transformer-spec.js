describe("services.transformer.UniversalReadingResponseTransformer", function () {
    var transformer, response;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);
        inject(function ($injector) {
            transformer = $injector.get('services.transformer.UniversalReadingResponseTransformer');
        });

        response = JSON.stringify([
            {data: {name: "George"}, taken_at: '10/09/12, 10:48:32'},
            {data: {name: "Stan"}, taken_at: '20/09/12, 07:18:32'},
            {data: {name: "Pete"}, taken_at: '10/09/12, 10:40:32'}
        ]);
    });

    it('Should return undefined if the data is undefined', function () {
        expect(transformer(undefined)).toBeUndefined();
    });

    it('Should return null when the data is null', function () {
        expect(transformer(null)).toBeNull();
    });

    it('Should return an empty array when the data is an empty array', function () {
        expect(transformer(JSON.stringify([]))).toEqual([]);
    });

    it('Should map the collection to each data element within the items', function () {
        expect(transformer(JSON.stringify([
            {data: {name: "George"}},
            {data: {name: "Stan"}},
            {data: {name: "Pete"}}
        ]))).toEqual([
                {name: "George", "Date Time": ""},
                {name: "Stan", "Date Time": ""},
                {name: "Pete", "Date Time": ""}
            ]);
    });

    it('Should add the taken_at property to the data on each element', function () {
        expect(transformer(response).length).toEqual(3);
    });
});