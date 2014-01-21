describe("controllers.ParentController", function () {
    var $rootScope,
        $scope,
        controller,
        pageData,
        dashboardServiceSpy,
        config;

    beforeEach(function () {
        dashboardServiceSpy = jasmine.createSpyObj('Dashboard Service', ['getCurrentUser']);
        dashboardServiceSpy.getCurrentUser.andReturn("Andy!");
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat(function($provide) {
            $provide.value('service.DashboardService', dashboardServiceSpy);
        }));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            pageData = $injector.get('values.DashboardPageData');
            config = $injector.get('constants.Config');
            controller = $injector.get('$controller')("controllers.ParentController", {$scope: $scope});
        });
    });

    describe('Event Listeners', function () {
        describe('config.EVENT.DASHBOARD_LOADED', function () {
            it('Should set $scope.loading to false', function () {
                $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADED);
                $rootScope.$digest();
                expect($scope.loading).toBeFalsy();
            });

            it('Should set the pageData.page to 0', function () {
                pageData.page = 1;
                $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADED);
                $rootScope.$digest();
                expect(pageData.page).toEqual(0);
            });
        });

        describe('config.EVENT.DASHBOARD_LOADING', function () {
            it('Should set $scope.loading to true', function () {
                $rootScope.$broadcast(config.EVENTS.DASHBOARD_LOADING);
                $rootScope.$digest();
                expect($scope.loading).toBeTruthy();
            });
        });
    });

    describe('Initialization', function () {
        it('Should call the dashboardService.getCurrentUser for the current user', function () {
            expect(dashboardServiceSpy.getCurrentUser).toHaveBeenCalledWith();
        });

        it('Should set the currentUser to the return of the service call', function () {
            expect($scope.user).toEqual("Andy!");
        });
    });
});