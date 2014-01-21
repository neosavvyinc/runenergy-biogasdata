describe("controllers.SiteController", function () {
    var $rootScope,
        $scope,
        controller,
        dashboardHeaderData,
        dashboardServiceSpy;

    beforeEach(function () {
        dashboardServiceSpy = jasmine.createSpyObj('Dashboard Service', ['getCustomers', 'getEntitledLocations']);
        module.apply(this, RunEnergy.Dashboard.Dependencies.concat(function($provide) {
            $provide.value('service.DashboardService', dashboardServiceSpy);
        }));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            dashboardHeaderData = $injector.get('values.DashboardHeaderData');
            controller = $injector.get('$controller')("controllers.SiteController", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should call dashboardService.getCustomers with nothing', function () {
            expect(dashboardServiceSpy.getCustomers).toHaveBeenCalledWith();
        });

        it('Should call dashboardService.getEntitledLocations with nothing', function () {
            expect(dashboardServiceSpy.getEntitledLocations).toHaveBeenCalledWith();
        });

        it('Should set $scope.dashboardHeaderData to dashboardHeaderData', function () {
            expect($scope.dashboardHeaderData).toEqual(dashboardHeaderData);
        });
    });

    describe('Watchers', function () {
        describe('locations', function () {
            it('Should set the dashboardHeaderData.site to the first value of the locations if it is defined', function () {
                expect(dashboardHeaderData.site).toBeNull();
                $scope.locations = [1, 2, 3];
                $scope.$digest();
                expect(dashboardHeaderData.site).toEqual(1);
            });
        });

        describe('dashboardHeaderData.customer', function () {
            it('Should set the dashboardHeaderData.customer to the first value of the customers', function () {
                expect(dashboardHeaderData.customer).toBeNull();
                $scope.customers = ["Mike", "George", "Tom"];
                $scope.$digest();
                expect(dashboardHeaderData.customer).toEqual("Mike");
            });
        });

        describe('dashboardHeaderData.site', function () {
            it('Should set the dashboardHeaderData.flareSpecification to the first item in the list of flare_specifications', function () {
                dashboardHeaderData.flareSpecification = null;
                expect(dashboardHeaderData.flareSpecification).toBeNull();
                dashboardHeaderData.site = {flare_specifications: [1, 2, 3]};
                $scope.$digest();
                expect(dashboardHeaderData.flareSpecification).toEqual(1);
            });
        });

    });
});