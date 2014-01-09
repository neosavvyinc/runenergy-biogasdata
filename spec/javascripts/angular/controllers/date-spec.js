describe("controllers.DateController", function () {
    var $rootScope,
        $scope,
        controller,
        config,
        dashboardDateData;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            config = $injector.get('constants.Config');
            dashboardDateData = $injector.get('values.DashboardDateData');
            controller = $injector.get('$controller')("controllers.DateController", {$scope: $scope});
        });
    });

    describe('Action Handlers', function () {
        describe('onApplyDateTimeFilters', function () {
            it('Should broadcast the event for APPLY_DATE_TIME_FILTERS', function () {
                var called = false;
                $rootScope.$on(config.EVENTS.APPLY_DATE_FILTERS, function() {
                    called = true;
                });
                $scope.onApplyDateTimeFilters();
                $rootScope.$digest();
                expect(called).toBeTruthy();
            });
        });

        describe('onClear', function () {
            beforeEach(function() {
               $scope.onClear();
            });

            it('Should set dashboardDateData.startDate to null', function () {
                expect(dashboardDateData.startDate).toBeNull();
            });

            it('Should set dashboardDateData.endDate to null', function () {
                expect(dashboardDateData.endDate).toBeNull();
            });

            it('Should set dashboardDateData.startTime to a blank string', function () {
                expect(dashboardDateData.startTime).toEqual("");
            });

            it('Should set dashboardDateData.endTime to a blank string', function () {
                expect(dashboardDateData.endTime).toEqual("");
            });

            it('Should broadcast the CLEAR_FILTERS event', function () {
                var called = false;
                $rootScope.$on(config.EVENTS.CLEAR_FILTERS, function() {
                    called = true;
                });
                $scope.onClear();
                $rootScope.$digest();
                expect(called).toBeTruthy();
            });
        });
    });

    describe('Initialization', function () {
        it('Should instantiate dashboardDateData on the $scope', function () {
            expect($scope.dashboardDateData).toEqual(dashboardDateData);
        });
    });
});