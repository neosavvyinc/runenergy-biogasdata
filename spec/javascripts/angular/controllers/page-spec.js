describe("controllers.PageController", function () {
    var $rootScope,
        $scope,
        routes,
        dashboardHeaderData,
        dashboardPageData,
        dashboardData,
        dashboardServiceSpy,
        controller;

    beforeEach(function () {
        dashboardServiceSpy = jasmine.createSpyObj('Dashboard Service Spy', ['getCSVExport']);
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            routes = $injector.get('constants.Routes');
            dashboardHeaderData = $injector.get('values.DashboardHeaderData');
            dashboardPageData = $injector.get('values.DashboardPageData');
            dashboardData = $injector.get('values.DashboardData');
            dashboardServiceSpy = spyOnAngularService($injector.get('service.DashboardService'), 'getCSVExport', {data: [1, 2, 3], constraints: true});
            controller = $injector.get('$controller')("controllers.PageController", {$scope: $scope});
        });
    });

    describe('Action Handlers', function () {

        describe('onNext', function () {
            it('Should increment dashboardPageData.page', function () {
                dashboardPageData.page = 0;
                $scope.onNext();
                expect(dashboardPageData.page).toEqual(1);
            });
        });

        describe('onPrevious', function () {
            it('Should not decrement page below 0', function () {
                dashboardPageData.page = 0;
                $scope.onPrevious();
                expect(dashboardPageData.page).toEqual(0);
            });

            it('Should decrement a page that is greater than zero', function () {
                dashboardPageData.page = 1;
                $scope.onPrevious();
                expect(dashboardPageData.page).toEqual(0);
            });
        });

        xdescribe('onExportCSV', function () {
            var eventSpy;

            beforeEach(function () {
                eventSpy = jasmine.createSpyObj('Event Spy', ['preventDefault']);
                dashboardHeaderData.flareSpecification = {id: 17};
                dashboardData.flareMonitorData = {
                    header: [
                        {attribute_name: 'name'},
                        {attribute_name: 'age'},
                        {attribute_name: 'country'}
                    ]
                };
                dashboardData.filters = [
                    {expression: '> 5'},
                    {expression: ''},
                    {expression: '== 28'}
                ];
            });

            it('Should call the event.preventDefault method', function () {
                $scope.onExportCSV(eventSpy);
                expect(eventSpy.preventDefault).toHaveBeenCalledWith();
            });
        });

    });

    describe('Getters', function () {
        describe('getExportCSVLink', function () {
            it('Should return a blank string when no flare specification is defined', function () {
                dashboardHeaderData.flareSpecification = null;
                expect($scope.getExportCSVLink()).toEqual("");
            });

            it('Should return the route with the flareSpecification.id appended', function () {
                dashboardHeaderData.flareSpecification = {id: 17};
                expect($scope.getExportCSVLink()).toEqual(
                    new Neosavvy.Core.Builders.RequestUrlBuilder(routes.DASHBOARD.CSV_EXPORT.READ).
                        addParam('flareSpecificationId', dashboardHeaderData.flareSpecification.id).
                        build()
                );
            });
        });
    });

    describe('Initialization', function () {
        it('Should put dashboardPageData on the $scope', function () {
            expect($scope.dashboardPageData).toEqual(dashboardPageData);
        });

        it('Should set exportingCSV to false', function () {
            expect($scope.exportingCSV).toBeFalsy();
        });
    });
});