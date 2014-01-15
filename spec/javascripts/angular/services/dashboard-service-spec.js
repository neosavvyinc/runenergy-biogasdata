describe("services.DashboardService", function () {
    var routes, service, nsServiceExtensionsSpy;

    beforeEach(function () {
        nsServiceExtensionsSpy = jasmine.createSpyObj('nsServiceExtensions', ['request', 'jqRequest']);
        module.apply(this, RunEnergy.Dashboard.Dependencies.concat(function($provide) {
            $provide.value("nsServiceExtensions", nsServiceExtensionsSpy);
        }));

        inject(function ($injector) {
            routes = $injector.get('constants.Routes');
            service = $injector.get('service.DashboardService');
        });
    });

    describe('getCurrentUser', function () {
        it('Should call the request spy with GET and the route', function () {
            service.getCurrentUser();
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.USER.READ});
        });
    });

    describe('getCustomers', function () {
        it('Should call the request spy with GET and the route', function () {
            service.getCustomers();
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.CUSTOMERS.READ});
        });
    });

    describe('getEntitledLocations', function () {
        it('Should be able to call the service with the customerId param', function () {
            service.getEntitledLocations(17);
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.LOCATIONS.READ + "?customerId=17"});
        });

        it('Should be able to call the service without the customerId param', function () {
            service.getEntitledLocations();
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.LOCATIONS.READ});
        });
    });

    describe('getEntitledFlareDeployments', function () {
        it('Should be able to call the service with GET and the route', function () {
            service.getEntitledFlareDeployments();
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.FLARE_DEPLOYMENTS.READ});
        });
    });

    describe('getEntitledFlareSpecifications', function () {
        it('Should call the service with GET and the route', function () {
            service.getEntitledFlareSpecifications();
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.FLARE_SPECIFICATIONS.READ});
        });
    });

    describe('getAllFlareMonitorData', function () {
        it('Should call with GET, the route, and all the params', function () {
            service.getAllFlareMonitorData(11, 54, 8989, "18:19", "19:00", 1, 7);
            expect(nsServiceExtensionsSpy.request).toHaveBeenCalledWith({method: 'GET', url: routes.DASHBOARD.FLARE_MONITOR_DATA.READ + "?flareSpecificationId=11&startDate=54&endDate=8989&startTime=18:19&endTime=19:00&start=1&end=7"});
        });
    });
});