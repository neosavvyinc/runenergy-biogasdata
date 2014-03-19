describe("", function () {
    var $rootScope,
        $scope,
        $compile,
        el,
        $body = $('body'),
        simpleHtml = '<div re-remove-from-dom="h2, p"><h2 data-reading-id="17">Content</h2><p data-reading-id="27">Other Content</p></div>',
        advancedHtml = '<div re-remove-from-dom=".special"><label class="special" data-collision-id="19" data-reading-id="1146">Some Label Content</label></div>';

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

    it('Should throw an error if no selectors are specified', function () {
        expect(function () {
            $compile(angular.element('<div re-remove-from-dom></div>'))($scope);
        }).toThrow();
    });

    it('Should remove the tr from the dom', function () {
        expect(el.find('h2').length).toEqual(1);
        $rootScope.$broadcast('REMOVE_FROM_DOM', {readingId: 17});
        $rootScope.$digest();
        expect(el.find('h2').length).toEqual(0);
    });

    it('Should remove the p from the dom', function () {
        expect(el.find('p').length).toEqual(1);
        $rootScope.$broadcast('REMOVE_FROM_DOM', {readingId: 27});
        $rootScope.$digest();
        expect(el.find('p').length).toEqual(0);
    });

    describe('advanced', function () {
        beforeEach(function () {
            el = $compile(angular.element(advancedHtml))($scope);
            $body.append(el);
            $rootScope.$digest();
        });

        it('Should not remove the label if the data elements are not exact', function () {
            expect(el.find('label').length).toEqual(1);
            $rootScope.$broadcast('REMOVE_FROM_DOM', {collisionId: 19, readingId: 224});
            $rootScope.$digest();
            expect(el.find('label').length).toEqual(1);
        });

        it('Should remove the label with the exact data combination', function () {
            expect(el.find('label').length).toEqual(1);
            $rootScope.$broadcast('REMOVE_FROM_DOM', {collisionId: 19, readingId: 1146});
            $rootScope.$digest();
            expect(el.find('label').length).toEqual(0);
        });
    });
});