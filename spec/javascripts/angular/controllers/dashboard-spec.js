describe("controllers.DashboardController", function () {
    var $rootScope,
        $scope,
        dashboardData,
        dashboardHeaderData,
        dashboardPageData,
        controller;

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            dashboardData = $injector.get('values.DashboardData');
            dashboardHeaderData = $injector.get('values.DashboardHeaderData');
            dashboardPageData = $injector.get('values.DashboardPageData');
            controller = $injector.get('$controller')("controllers.DashboardController", {$scope: $scope});
        });
    });

    describe('Getters', function () {
        describe('getSignificantDigits', function () {
            it('Should return 2 if significant digits is not a number', function () {
                dashboardData.flareMonitorData = {header: [{significant_digits: "TOM"}]};
                expect($scope.getSignificantDigits(0)).toEqual(2);
            });

            it('Should return the significant digits value if it is a number', function () {
                dashboardData.flareMonitorData = {header: [{significant_digits: "TOM"}, {significant_digits: 15}]};
                expect($scope.getSignificantDigits(1)).toEqual(15);
            });
        });
    });

    describe('Initialization', function () {
        it('Should set dashboardData on the $scope', function () {
            expect($scope.dashboardData).toEqual(dashboardData);
        });

        it('Should set dashboardHeaderData on the $scope', function () {
            expect($scope.dashboardHeaderData).toEqual(dashboardHeaderData);
        });

        it('Should set dashboardPageData on the $scope', function () {
            expect($scope.dashboardPageData).toEqual(dashboardPageData);
        });
    });
});