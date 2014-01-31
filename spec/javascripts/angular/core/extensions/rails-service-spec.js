describe("nsRailsService", function () {
    var nsServiceExtensionsSpy,
        service;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat(function ($provide) {
            nsServiceExtensionsSpy = jasmine.createSpyObj('nsServiceExtensions', ['request', 'jqRequest', 'xhr']);

            $provide.value('nsServiceExtensions', nsServiceExtensionsSpy);
        }));

        inject(function ($injector) {
            service = $injector.get('nsRailsService');
        });
    });

    it('Should throw an error if called with undefined', function () {
        expect(function () {
            service.request(undefined);
        }).toThrow();
    });

    it('Should throw an error if called with null', function () {
        expect(function () {
            service.request(null);
        }).toThrow();
    });

    it('Should throw an error if called with a non object type', function () {
        expect(function () {
            service.request('this is a string');
        }).toThrow();
    });

    it('Should be able to make a vanilla request with just a method and a url', function () {
        service.request({method: 'GET', url: 'something'});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: 'something'});
    });

    it('Should replace params by name in the url', function () {
        service.request({method: 'GET', url: 'something/:id/monitor/:name', params: {':id': 17, ':name': 'Kentucky'}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: 'something/17/monitor/Kentucky'});
    });

    it('Should be able to append optional params to the end of the url', function () {
        service.request({method: 'GET', url: 'something/monitor', optional: {shorts: 78, pants: 16}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: 'something/monitor?shorts=78&pants=16'});
    });

    it('Should convert js data keys to snake case from camel', function () {
        service.request({method: 'PUT', url: 'google.com/api', data: {monitorClassId: 18, locationName: 'Sherwood Forest', readingMods: {columnDelete: true, happy: false}}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'PUT', url: 'google.com/api', data: {monitor_class_id: 18, location_name: 'Sherwood Forest', reading_mods: {column_delete: true, happy: false}}});
    });

    it('Should removed undefined optional parameters', function () {
        service.request({method: 'GET', url: 'something/monitor', optional: {shorts: 78, pants: 16, jacket: undefined}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: 'something/monitor?shorts=78&pants=16'});
    });

    it('Should remove null optional parameters', function () {
        service.request({method: 'GET', url: 'something/monitor', optional: {shorts: 78, pants: 16, hat: null, coat: null}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: 'something/monitor?shorts=78&pants=16'});
    });

    it('Should remove blank optional parameters', function () {
        service.request({method: 'GET', url: 'something/monitor', optional: {shorts: 78, pants: 16, zone: 0, tacos: "", burger: " "}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: 'something/monitor?shorts=78&pants=16&zone=0'});
    });

    it('Should be able to combine these paradigms effectively', function () {
        service.request({method: 'POST', url: 'google.com/api/:id/:age/create',
            params: {':id': 89, ':age': 'old'},
            optional: {cheese: "Cheddar"},
            data: {monitorClassId: 18, locationName: 'Sherwood Forest', readingMods: {columnDelete: true, happy: false}}});
        expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'POST', url: 'google.com/api/89/old/create?cheese=Cheddar', data: {monitor_class_id: 18, location_name: 'Sherwood Forest', reading_mods: {column_delete: true, happy: false}}});
    });
});