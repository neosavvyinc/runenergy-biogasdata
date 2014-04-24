describe("HeatMapCtrl", function () {
    var $rootScope,
        $scope,
        controller;

    beforeEach(function () {
        module('runenergy.dashboard.directives');

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            controller = $injector.get('$controller')("HeatMapCtrl", {$scope: $scope});
        });
    });
});

describe("reHeatMap", function () {
    var $rootScope,
        $scope,
        el,
        $body = $('body'),
        simpleHtml = '<div re-heat-map></div>';

    beforeEach(function () {
        module('runenergy.dashboard.directives');

        inject(function ($injector, $compile) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            el = $compile(angular.element(simpleHtml))($scope);
        });

        $body.append(el);
        $rootScope.$digest();
    });

    afterEach(function () {
        $body.empty();
    });

    it('Should return true', function () {
        expect(true).toBeTruthy();
    });
});