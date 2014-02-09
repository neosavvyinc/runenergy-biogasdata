describe("controllers.helpers.DataTable", function () {
    var $rootScope,
        $scope,
        railsService,
        routes,
        controller;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat(function ($provide) {
            railsService = jasmine.createSpyObj("railsService", ["request"]);
            railsService.request.andReturn({then: function (fn) {
                fn({readings: [], deleted: []});
            }});
            $provide.value('nsRailsService', railsService);
        }));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();

            //Stuff inherited from other scope
            $scope.approvals = {};
            
            routes = $injector.get('constants.Routes');
            controller = $injector.get('$controller')("controllers.helpers.DataTable", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should instantiate readingMods on the $scope', function () {
            expect($scope.readingMods).toEqual({
                deletedIds: {}
            });
        });
    });

    describe('Action Handlers', function () {

        beforeEach(function () {
            $scope.data = [{id: 1}, {id: 2}, {id: 3}];
        });

        describe('onRemoveRow', function () {
            it('Should be able to add the id to the deleted ids object', function () {
                $scope.onRemoveRow(2);
                expect($scope.readingMods.deletedIds["3"]).toBeTruthy();
            });

            it('Should be able to remove the id from the deleted ids object', function () {
                $scope.readingMods.deletedIds["1"] = true;
                $scope.onRemoveRow(0);
                expect($scope.readingMods.deletedIds["1"]).toBeUndefined();
            });
        });

        describe('onApproveLimits', function () {

            it('Should throw an error when there is no data on the $scope', function () {
                $scope.data = null;
                expect(function () {
                    $scope.onApproveLimits();
                }).toThrow();
            });

            describe('with data', function () {
                beforeEach(function () {
                    $scope.readingMods.deletedIds = {'2': true};
                });

                it('Should call the railsService', function () {
                    $scope.onApproveLimits();
                    expect(railsService.request).toHaveBeenCalledWith({
                        method: 'POST',
                        url: routes.DATA_INPUT.APPROVE_LIMIT_BREAKING_SET,
                        data: {
                            readings: [{id: 1}, {id: 2}, {id: 3}],
                            deletedIds: $scope.readingMods.deletedIds,
                            type: undefined
                        }});
                });

                it('Should set $scope.data to null', function () {
                    $scope.onApproveLimits();
                    expect($scope.data).toBeNull();
                });

                it('Should set $scope.loading to false', function () {
                    expect($scope.loading).toBeFalsy();
                });
            });

        });

    });

    describe('Getters', function () {

        describe('getDeleted', function () {
            it('Should return false if not passed an id', function () {
                expect($scope.getDeleted(undefined)).toBeFalsy();
            });

            it('Should return true if it is deleted', function () {
                $scope.readingMods.deletedIds['25'] = true;
                expect($scope.getDeleted(25)).toBeTruthy();
            });

            it('Should return false if it is not', function () {
                expect($scope.getDeleted(74)).toBeFalsy();
            });
        });

    });

});