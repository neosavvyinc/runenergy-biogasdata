describe("controllers.DataInputImportController", function () {
    var $rootScope,
        $scope,
        $filter,
        routes,
        controller,
        newDataValues,
        railsService,
        readingTransformerSpy,
        createTransformerSpy;

    beforeEach(module('runenergy.dashboard.controllers', function ($provide) {
        readingTransformerSpy = jasmine.createSpy().andReturn("Jimminy Crickets!");
        createTransformerSpy = jasmine.createSpy().andReturn("Jimminy Createkits!");
        $provide.value('services.transformer.UniversalReadingResponseTransformer', readingTransformerSpy);
        $provide.value('services.transformer.DataInputCreateTransformer', createTransformerSpy);
    }));

    beforeEach(function () {
        module.apply(this, [
            'runenergy.dashboard.controllers',
            'runenergy.dashboard.services',
            'runenergy.dashboard.constants',
            'runenergy.dashboard.values',
            'runenergy.dashboard.filters'
        ].concat(Neosavvy.AngularCore.Dependencies).concat(function ($provide) {
                railsService = jasmine.createSpyObj("railsService", ["request"]);
                railsService.request.andReturn({then: function (fn) {
                    fn({readings: [], deleted: []});
                }});
                $provide.value('nsRailsService', railsService);
            }));

        inject(function ($injector, _$filter_) {
            $filter = _$filter_;
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            routes = $injector.get('constants.Routes');
            newDataValues = $injector.get('values.NewDataValues');
            controller = $injector.get('$controller')("controllers.DataInputImportController", {$scope: $scope});
        });
    });

    describe('Initialization', function () {
        it('Should set $scope.columnNameRow to 1', function () {
            expect($scope.columnNameRow).toEqual(1);
        });

        it('Should set $scope.firstDataRow to 2', function () {
            expect($scope.firstDataRow).toEqual(2);
        });

        it('Should instantiate $scope.readingMods', function () {
            expect($scope.readingMods).toEqual({
                deletedRowIndices: [],
                deletedColumns: {},
                columnToMonitorPointMappings: {},
                assetColumnName: null,
                dateColumnName: null,
                dateFormat: null
            });
        });

        it('Should instantiate newDataValues as a property on the scope', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });

        it('Should instantiate approvals', function () {
            expect($scope.approvals).toEqual({
                upperLimit: false,
                lowerLimit: false
            });
        });

        it('Should set $scope.readingDate to null', function () {
            expect($scope.readingDate).toBeNull();
        });
    });

    describe('Watchers', function () {

        describe('data', function () {
            it('Should not call the reading transformer or set the data on the scope with an empty return', function () {
                $scope.data = null;
                $scope.$digest();
                expect(readingTransformerSpy).not.toHaveBeenCalled();
            });

            it('Should call the readingTransformer with the data', function () {
                $scope.data = [1, 2, 3, 4];
                $scope.$digest();
                expect(readingTransformerSpy).toHaveBeenCalledWith([1, 2, 3, 4]);
            });

            it('Should set the transformed data on the scope', function () {
                $scope.data = [1, 2, 3, 4];
                $scope.$digest();
                expect($scope.data).toEqual("Jimminy Crickets!");
            });
        });

        describe('columnNameRow, firstDataRow', function () {
            it('Should set $scope.requiredFieldsMissing to true when columnNameRow is blank on the scope', function () {
                $scope.firstDataRow = 25;
                $scope.columnNameRow = null;
                $scope.$digest();
                expect($scope.requiredFieldsMissing).toBeTruthy();
            });

            it('Should set $scope.requiredFieldsMissing to true when firstDataRow is blank on the scope', function () {
                $scope.columnNameRow = 13;
                $scope.firstDataRow = null;
                $scope.$digest();
                expect($scope.requiredFieldsMissing).toBeTruthy();
            });

            it('Should set $scope.requiredFieldsMissing to false when neither is blank on the scope', function () {
                $scope.firstDataRow = 25;
                $scope.columnNameRow = 13;
                $scope.$digest();
                expect($scope.requiredFieldsMissing).toBeFalsy();
            });
        });

        describe('newDataValues.selectedLocationsMonitorClass', function () {

            it('Should set the $scope.readingMods.columnToMonitorPointMappings when the value is set', function () {
                expect($scope.readingMods.columnToMonitorPointMappings).toEqual({});
                newDataValues.selectedLocationsMonitorClass = {column_cache: {name: 'George', age: 42}};
                $scope.$digest();
                expect($scope.readingMods.columnToMonitorPointMappings).toEqual({name: 'George', age: 42});
            });

            it('Should set the $scope.deletedColumns when the value is set', function () {
                expect($scope.readingMods.deletedColumns).toEqual({});
                newDataValues.selectedLocationsMonitorClass = {deleted_column_cache: {name: true, color: true}};
                $scope.$digest();
                expect($scope.readingMods.deletedColumns).toEqual({name: true, color: true});
            });

            it('Should set the readingMods.assetColumnName if the val has one assigned', function () {
                newDataValues.selectedLocationsMonitorClass = {deleted_column_cache: {name: true, color: true}, asset_column_name: 'Blue'};
                $scope.$digest();
                expect($scope.readingMods.assetColumnName).toEqual('Blue');
            });

            it('Should set the readingMods.dateColumnName if the val has one assigned', function () {
                newDataValues.selectedLocationsMonitorClass = {date_column_name: 'Date Time'};
                $scope.$digest();
                expect($scope.readingMods.dateColumnName).toEqual('Date Time');
            });

            it('Should set the readingMods.dateFormat if the val has one assigned', function () {
                newDataValues.selectedLocationsMonitorClass = {date_format: '%d-%b-%y - 1000'};
                $scope.$digest();
                expect($scope.readingMods.dateFormat).toEqual('%d-%b-%y - 1000');
            });
        });

        describe('readingMods.dateColumnName', function () {

            beforeEach(function () {
                newDataValues.selectedLocationsMonitorClass = {date_format: ''};
                $scope.readingMods.dateColumnName = 'Taken Up';
                $scope.$digest();
            });

            it('Should set the default dateFormat on readingMods', function () {
                expect($scope.readingMods.dateFormat).toEqual('%d-%b-%y');
            });

            it('Should deregister the watcher so it cannot be called again', function () {
                $scope.readingMods.dateFormat = 'Another';
                $scope.$digest();
                expect($scope.readingMods.dateFormat).toEqual('Another');
            });

        });
    });

    describe('Action Handlers', function () {
        describe('onCompleteImport', function () {
            beforeEach(function () {
                $scope.data = [{id: 0, $$hashKey: 19}, {id: 2, $$hashKey: 20}, {id: 3, $$hashKey: 21}];
                $scope.readingMods.assetColumnName = 'id';
                $scope.readingDate = new Date();
                newDataValues.selectedSite = {id: 19};
                newDataValues.selectedMonitorClass = {id: 17};
            });

            it('Should set the error if no readingMods.assetColumnName is set', function () {
                $scope.readingMods.assetColumnName = '';
                $scope.onCompleteImport();
                expect($scope.error).toEqual("Please select an asset column for your spreadsheet.");
            });

            it('Should set the error if no readingDate is set', function () {
                $scope.readingDate = null;
                $scope.onCompleteImport();
                expect($scope.error).toEqual("You must specify a reading date for the import.");
            });

            it('Should set the error if the assigned and deleted colums are not equal to the data columns', function () {
                $scope.data = [{id: 0, $$hashKey: 19, somethingElse: 18}];
                $scope.onCompleteImport();
                expect($scope.error).toEqual("You have not assigned or removed every column.");
            });

            it('Should call the nsRailsService with the params', function () {
                var dataBefore = $scope.data;
                $scope.onCompleteImport();
                expect(railsService.request).toHaveBeenCalledWith({
                    method: 'POST',
                    url: routes.DATA_INPUT.COMPLETE_IMPORT,
                    ignoreDataKeys: true,
                    data: {
                        site_id: newDataValues.selectedSite.id,
                        monitor_class_id: newDataValues.selectedMonitorClass.id,
                        asset_column_name: $scope.readingMods.assetColumnName,
                        readings: dataBefore,
                        reading_date: $filter('reDateToEpoch')($scope.readingDate),
                        reading_mods: {
                            deleted_row_indices: $scope.readingMods.deletedRowIndices,
                            deleted_columns: $scope.readingMods.deletedColumns,
                            column_to_monitor_point_mappings: $scope.readingMods.columnToMonitorPointMappings,
                            date_column_name: $scope.readingMods.dateColumnName,
                            date_format: $scope.readingMods.dateFormat
                        }
                    }
                });
            });

            it('Should set $scope.data to null', function () {
                $scope.data = [{id: 0, $$hashKey: 19}, {id: 2, $$hashKey: 20}, {id: 3, $$hashKey: 21}];
                $scope.readingMods.assetColumnName = 'id';
                $scope.readingDate = new Date();
                $scope.onCompleteImport();
                expect($scope.data).toBeNull();
            });
        });

        describe('onSetAssetColumn', function () {
            it('Should set the $scope.readingMods.assetColumnName to the column passed into the function', function () {
                expect($scope.readingMods.assetColumnName).toBeNull();
                $scope.onSetAssetColumn("Identifier 20");
                expect($scope.readingMods.assetColumnName).toEqual("Identifier 20");
            });

            it('Should not be able to set the currently defined date column as the asset column', function () {
                $scope.readingMods.dateColumnName = "Taken";
                $scope.onSetAssetColumn("Taken");
                expect($scope.readingMods.assetColumnName).toBeNull();
            });
        });

        describe('onSetDateColumn', function () {
            it('Should set the $scope.readingMods.dateColumnName to the column passed into the function', function () {
                expect($scope.readingMods.dateColumnName).toBeNull();
                $scope.onSetDateColumn("Date & Time");
                expect($scope.readingMods.dateColumnName).toEqual("Date & Time");
            });

            it('Should not be able to set the currently defined asset column as the date column', function () {
                $scope.readingMods.assetColumnName = "Taken2";
                $scope.onSetDateColumn("Taken2");
                expect($scope.readingMods.dateColumnName).toBeNull();
            });
        });

        describe('onSubmit', function () {
            var eSpy;

            beforeEach(function () {
                newDataValues.selectedSite = {id: 29};
                newDataValues.selectedMonitorClass = {id: 25};
                eSpy = jasmine.createSpyObj('e', ['preventDefault']);
            });

            it('Should preventDefault of event if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.onSubmit(eSpy);
                expect(eSpy.preventDefault).toHaveBeenCalledWith();
            });

            it('Should set $scope.error if there is no selected site', function () {
                newDataValues.selectedSite = null;
                $scope.onSubmit(eSpy);
                expect($scope.error).toEqual('You must select a site before uploading');
            });

            it('Should preventDefault of event if there is no selectedMonitorClass', function () {
                newDataValues.selectedMonitorClass = null;
                $scope.onSubmit(eSpy);
                expect(eSpy.preventDefault).toHaveBeenCalledWith();
            });

            it('Should set $scope.error if there is no selected monitor class', function () {
                newDataValues.selectedMonitorClass = null;
                $scope.onSubmit(eSpy);
                expect($scope.error).toEqual('You must select a monitor class before uploading');
            });

            it('Should not prevent the default if there is both', function () {
                $scope.onSubmit(eSpy);
                expect(eSpy.preventDefault).not.toHaveBeenCalled();
            });

        });
    });

    describe('Getters', function () {
        describe('getFormPostUrl', function () {
            beforeEach(function () {
                newDataValues.selectedLandfillOperator = {id: 15};
                newDataValues.selectedSite = {id: 16};
                newDataValues.selectedMonitorClass = {id: 17};
                newDataValues.selectedSection = {id: 18};
                newDataValues.selectedAsset = {id: 21};
            });

            it('Should return the base url with all the params', function () {
                expect($scope.getFormPostUrl('/data_input/import', newDataValues)).toEqual('/data_input/import?operator=15&site=16&monitor_class=17&section=18&asset=21');
            });
        });
    });
});