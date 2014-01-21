describe("reMonitorLimit", function () {
    var $rootScope,
        $scope,
        el,
        $compile,
        $body = $('body'),
        simpleHtml = '<input ng-model="something" re-monitor-limit="jordan">';

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector, _$compile_) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            $compile = _$compile_;
            el = $compile(angular.element(simpleHtml))($scope);
        });

        $body.append(el);
        $rootScope.$digest();
    });

    afterEach(function () {
        $body.empty();
    });

    it('Should throw an error when compiled without a direct attribute value', function () {
        expect(function () {
            $compile(angular.element('<input ng-model="yeah" re-monitor-limit>'))($scope);
            $scope.$digest();
        }).toThrow();
    });
});