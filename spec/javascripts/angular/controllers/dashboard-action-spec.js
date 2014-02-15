ddescribe("controllers.DashboardActionController", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller,
        nsRailsServiceSpy,
        routes;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat(function ($provide) {
            nsRailsServiceSpy = jasmine.createSpyObj('nsRailsService', ['request']);
            nsRailsServiceSpy.request.andReturn({then: function (fn) {
                fn();
            }});
            $provide.value('nsRailsService', nsRailsServiceSpy);
        }));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            routes = $injector.get('constants.Routes');
            controller = $injector.get('$controller')("controllers.DashboardActionController", {$scope: $scope});
        });
    });

    describe('Watchers', function () {
        it('Should set the newDataValues.selectedLandFillOperator to the first one in the list when it is initialized', function () {
            expect(newDataValues.selectedLandfillOperator).toBeNull();
            $scope.landfillOperators = ["Lemmy", "Ronnie James", "Ozzy"];
            $scope.$digest();
            expect(newDataValues.selectedLandfillOperator).toEqual("Lemmy");
        });

        describe('_resetValuesBelow', function () {
            beforeEach(function() {
                newDataValues.selectedLandfillOperator = {id: 15};
                newDataValues.selectedSite = {id: 16};
                newDataValues.selectedMonitorClass = {id: 17};
                newDataValues.selectedSection = {id: 18};
                $scope.$digest();
                $scope.onFirstUserInteract();
            });

            xit('Should set everything to null when selectedLandfillOperator is changed', function () {
                $scope.newDataValues.selectedLandfillOperator = {id: 60};
                $scope.$digest();
                expect(newDataValues.selectedSite).toBeNull();
                expect(newDataValues.selectedMonitorClass).toBeNull();
                expect(newDataValues.selectedAsset).toBeNull();
            });

            it('Should set monitor class, section and asset to null when site is changed', function () {

            });

            it('Should set section and asset to null when monitor class is changed', function () {

            });

            it('Should set asset to null when section is changed', function () {

            });
        });

    });

    describe('Initialization', function () {
        it('Should set landfillOperators to null', function () {
            expect($scope.landfillOperators).toBeNull();
        });

        it('Should set sites to null', function () {
            expect($scope.sites).toBeNull();
        });

        it('Should set monitorClasses to null', function () {
            expect($scope.monitorClasses).toBeNull();
        });

        it('Should set sections to null', function () {
            expect($scope.sections).toBeNull();
        });

        it('Should set assets to null', function () {
            expect($scope.assets).toBeNull();
        });

        it('Should set newDataValues to the values object', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });

        it('Should set availableSites to null', function () {
            expect($scope.availableSites).toBeNull();
        });

        it('Should set availableSections to null', function () {
            expect($scope.availableSections).toBeNull();
        });

        it('Should set availableAssets to null', function () {
            expect($scope.availableAssets).toBeNull();
        });

        it('Should set availableMonitorClasses to null', function () {
            expect($scope.availableMonitorClasses).toBeNull();
        });
    });

    describe('Action Handlers', function () {
        describe('onFirstUserInteract', function () {
            beforeEach(function() {
                $scope.onFirstUserInteract();
            });

            it('Should add a watcher for newDataValues.selectedLandFillOperator', function () {
                expect(_.map($scope.$$watchers, 'exp')).toContain('newDataValues.selectedLandfillOperator');
            });

            it('Should add a watcher for newDataValues.selectedSite', function () {
                expect(_.map($scope.$$watchers, 'exp')).toContain('newDataValues.selectedSite');
            });

            it('Should add a watcher for newDataValues.selectedMonitorClass', function () {
                expect(_.map($scope.$$watchers, 'exp')).toContain('newDataValues.selectedMonitorClass');
            });

            it('Should add a watcher for newDataValues.selectedSection', function () {
                expect(_.map($scope.$$watchers, 'exp')).toContain('newDataValues.selectedSection');
            });
        });

        describe('onReset', function () {

            beforeEach(function () {
                newDataValues.selectedSection = {id: 27};
                newDataValues.selectedAsset = {id: 90};
            });

            it('Should set newDataValues.selectedSection to null', function () {
                $scope.onReset();
                expect(newDataValues.selectedSection).toBeNull();
            });

            it('Should set newDataValues.selectedAsset to null', function () {
                $scope.onReset();
                expect(newDataValues.selectedAsset).toBeNull();
            });

        });
    });
});