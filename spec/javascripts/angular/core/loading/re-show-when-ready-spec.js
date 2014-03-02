describe("reShowWhenReady", function () {
    var $rootScope,
        $scope,
        el,
        $body = $('body'),
        simpleHtml = '<p style="display: none; color: red;" re-show-when-ready>Some Text!</p>';

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

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

    it('Should have the display: none; block replaced', function () {
        expect(el.attr("style")).toEqual(" color: red;");
    });
});