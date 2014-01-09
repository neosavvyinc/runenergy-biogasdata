describe("services.AnalysisService", function () {
    var factory,
        routes,
        requestSpy;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            requestSpy = spyOn($injector.get('nsServiceExtensions'), 'request');
            routes = $injector.get('constants.Routes');
            factory = $injector.get('services.AnalysisService');
        });
    });

    describe('readings', function () {
        it('Should throw an error when it is not passed a siteId', function () {
            expect(function () {
                factory.readings(11, null, 29, 89);
            }).toThrow();
        });

        it('Should call the requestSpy with the params expected', function () {
            factory.readings(11, 23, 4, 35);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'GET',
                url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.ANALYSIS.READINGS).
                    paramReplace(":site_id", 23).
                    build()
            });
        });
    });

    describe('monitorPoints', function () {
        it('Should throw an error if not passed an assetId', function () {
            expect(function () {
                factory.monitorPoints();
            }).toThrow();
        });

        it('Should call the requestSpy with the params expected', function () {
            factory.monitorPoints(59);
            expect(requestSpy).toHaveBeenCalledWith({
                method: 'GET',
                url: new Neosavvy.Core.Builders.RequestUrlBuilder(routes.ANALYSIS.MONITOR_POINTS).
                    paramReplace(":asset_id", 59).
                    build()
            });
        });
    });
});