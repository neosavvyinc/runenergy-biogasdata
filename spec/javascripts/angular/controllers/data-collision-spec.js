describe("controllers.DataCollision", function () {
    var $rootScope,
        $scope,
        routes,
        nsRailsService,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat({
            nsRailsService: jasmine.createSpyObj('nsRailsService', ['request'])
        }));

        inject(function ($injector, _nsRailsService_) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            routes = $injector.get('constants.Routes');
            nsRailsService = _nsRailsService_;
            nsRailsService.request.andReturn({then: function (fn) {
                fn();
            }});
            controller = $injector.get('$controller')("controllers.DataCollision", {$scope: $scope});
        });
    });

    describe('Action Handlers', function () {

        describe('onResolve', function () {
            it('Should call the nsRailsService.request method', function () {
                $scope.onResolve({readingId: 16, collisionId: 18});
                expect(nsRailsService.request).toHaveBeenCalledWith({
                    method: 'POST',
                    url: routes.DATA_COLLISION.RESOLVE,
                    data: {readingId: 16, collisionId: 18}
                });
            });

            it('Should return the service call and broadcast and event with the data passed in', function () {
                var broadCastSpy = spyOn($rootScope, '$broadcast');
                $scope.onResolve({readingId: 16, collisionId: 18});
                expect(broadCastSpy).toHaveBeenCalledWith('REMOVE_FROM_DOM', {readingId: 16, collisionId: 18});
            });
        });

    });
});