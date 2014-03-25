describe("controllers.DashboardActionController", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller,
        nsRailsServiceSpy,
        locationSpy,
        routes,
        notifications;

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies.concat(function ($provide) {
            //nsRailsService
            nsRailsServiceSpy = jasmine.createSpyObj('nsRailsService', ['request']);
            nsRailsServiceSpy.request.andReturn({then: function (fn) {
                fn();
            }});
            $provide.value('nsRailsService', nsRailsServiceSpy);

            //$location
            locationSpy = jasmine.createSpyObj('$location', ['search']);
            locationSpy.search.andReturn({site: 13, monitor_class: 14, section: 10, asset: 1});
            $provide.value('$location', locationSpy);
        }));

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            routes = $injector.get('constants.Routes');
            notifications = $injector.get('values.Notifications');
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

        describe('_initValue', function () {

            it('Should set the selectionSection on scope to the one referenced in the url', function () {
                $scope.sections = [{id: 8}, {id: 10}, {id: 11}];
                $scope.$digest();
                expect(newDataValues.selectedSection).toEqual({id: 10});
            });

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

            it('Should set everything to null when selectedLandfillOperator is changed', function () {
                $scope.newDataValues.selectedLandfillOperator = {id: 60};
                $scope.$digest();
                $scope.newDataValues.selectedLandfillOperator = {id: 61};
                $scope.$digest();
                expect(newDataValues.selectedSite).toBeNull();
                expect(newDataValues.selectedMonitorClass).toBeNull();
                expect(newDataValues.selectedAsset).toBeNull();
            });

            it('Should call $location.search with the property name and the new prop', function () {
                $scope.newDataValues.selectedMonitorClass = {id: 19};
                $scope.$digest();
                $scope.newDataValues.selectedMonitorClass = {id: 22};
                $scope.$digest();
                expect(locationSpy.search).toHaveBeenCalledWith('monitor_class', 22);
            });

        });

        describe('newDataValues.selectedLandfillOperator', function () {

            beforeEach(function () {
                $scope.sites = [{id: 20}, {id: 21}, {id: 22}];
                newDataValues.selectedLandfillOperator = {id: 27, location_ids: [20, 22]};
                $scope.$digest();
            });

            it('Should choose the $scope.availableSites from the location_ids', function () {
                expect($scope.availableSites).toEqual([{id: 20}, {id: 22}]);
            });

        });

        describe('newDataValues.selectedSite', function () {

            beforeEach(function () {
                $scope.monitorClasses = [{id: 24}, {id: 25}, {id: 26}];
                $scope.sections = [{id: 28}, {id: 29}, {id: 30}];
                newDataValues.selectedSite = {id: 27, monitor_class_ids: [26], section_ids: [29, 30, 31]};
                $scope.$digest();
            });

            it('Should choose the $scope.availableMonitorClasses from the moitor_class_ids', function () {
                expect($scope.availableMonitorClasses).toEqual([{id: 26}]);
            });

            it('Should choose the $scope.availableSections from the section_ids', function () {
                expect($scope.availableSections).toEqual([
                    {id: 29},
                    {id: 30}
                ]);
            });

        });

        describe('newDataValues.selectedAsset', function () {

            beforeEach(function () {
                $scope.sites = [{id: 20}, {id: 21}, {id: 22}];
                $scope.monitorClasses = [{id: 24}, {id: 25}, {id: 26}];
                $scope.sections = [{id: 28}, {id: 29}, {id: 30}];
                newDataValues.selectedAsset = {id: 90, location_id: 22, monitor_class_id: 24, section_id: 29};
                $scope.$digest();
            });

            it('Should choose the site from the list of sites based on the assets location_id', function () {
                expect(newDataValues.selectedSite).toEqual({id: 22});
            });

            it('Should choose the monitor class from the list based on the assets monitor_class_id', function () {
                expect(newDataValues.selectedMonitorClass).toEqual({id: 24});
            });

            it('Should choose the section from the list based on assets section_id', function () {
                expect(newDataValues.selectedSection).toEqual({id: 29});
            });

        });

        describe('newDataValues.enable.plotMonitorPoint', function () {

            it('Should set the newDataValues.enable.heatMap to false', function () {
                newDataValues.enable.heatMap = true;
                $scope.$digest();
                newDataValues.enable.plotMonitorPoint = true;
                $scope.$digest();
                expect(newDataValues.enable.heatMap).toBeFalsy();
            });

        });

        describe('newDataValues.enable.heatMap', function () {

            it('Should set the newDataValues.enable.plotMonitorPoint to false', function () {
                newDataValues.enable.plotMonitorPoint = true;
                $scope.$digest();
                newDataValues.enable.heatMap = true;
                $scope.$digest();
                expect(newDataValues.enable.plotMonitorPoint).toBeFalsy();
            });

        });

        describe('heatMapMax', function () {

            it('Should call the $location.search method with max when it has a value', function () {
                $scope.heatMapMax = 102;
                $scope.$digest();
                expect(locationSpy.search).toHaveBeenCalledWith('max', 102);
            });

            it('Should not call $location.search when there is no value', function () {
                $scope.heatMapMax = null;
                $scope.$digest();
                expect(locationSpy.search).not.toHaveBeenCalled();
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
                $scope.onReset();
            });

            it('Should set newDataValues.selectedSection to null', function () {
                expect(newDataValues.selectedSection).toBeNull();
            });

            it('Should set newDataValues.selectedAsset to null', function () {
                expect(newDataValues.selectedAsset).toBeNull();
            });

            it('Should call $location.search("section", null)', function () {
                expect(locationSpy.search).toHaveBeenCalledWith("section", null);
            });

            it('Should call $location.search("asset", null)', function () {
                expect(locationSpy.search).toHaveBeenCalledWith("asset", null);
            });
            
        });

        describe('onSaveEdit', function () {
            it('Should increment the editSavedTrigger', function () {
                expect(notifications.editSavedTrigger).toEqual(0);
                $scope.onSaveEdit();
                expect(notifications.editSavedTrigger).toEqual(1);
            });
        });
    });
});