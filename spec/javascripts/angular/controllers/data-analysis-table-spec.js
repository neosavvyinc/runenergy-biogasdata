describe("controllers.DataAnalysisTable", function () {
    var $rootScope,
        $scope,
        newDataValues,
        controller,
        routes,
        notifications,
        stripAngularKeysRequest,
        railsServiceSpy,
        $timeout;

    var hpGet = Neosavvy.Core.Utils.MapUtils.highPerformanceGet;
    var _epochDateFor = function (dateTime) {
        if (dateTime) {
            return parseInt(dateTime.getTime() / 1000)
        }
        return dateTime;
    };

    describe('Getters', function () {
        describe('getColumnLabel', function () {
            it('Should return undefined when passed undefined for the key', function () {
                expect($scope.getColumnLabel(undefined, "%")).toBeUndefined();
            });

            it('Should return the key when passed null for the key', function () {
                expect($scope.getColumnLabel(null, "pH")).toBeNull();
            });

            it('Should return the key when passed a blank string for the key', function () {
                expect($scope.getColumnLabel("", "Oz.")).toEqual("");
            });

            it('Should return just the key', function () {
                expect($scope.getColumnLabel("Methane", null)).toEqual("Methane");
            });

            it('Should return the key plus the units if defined', function () {
                expect($scope.getColumnLabel("Methane", {unit: "%"})).toEqual("Methane (%)");
            });
        });

        describe('getEdit', function () {

            it('Should return false when the row under edit is not the one passed in', function () {
                newDataValues.currentUser = {can_edit: true}
                $scope.onEditRow({$$hashKey: 'CMU50'});
                expect($scope.getEdit({$$hashKey: 'CMU'})).toBeFalsy();
            });

            it('Should return when the row.$$hashKey is equal to the underEdit value, only if th user can edit', function () {
                newDataValues.currentUser = {can_edit: false}
                $scope.onEditRow({$$hashKey: 'CMU'});
                expect($scope.getEdit({$$hashKey: 'CMU'})).toBeFalsy();
            });

            it('Should return when the row.$$hashKey is equal to the underEdit value, only if th user can edit', function () {
                newDataValues.currentUser = {can_edit: true}
                $scope.onEditRow({$$hashKey: 'CMU'});
                expect($scope.getEdit({$$hashKey: 'CMU'})).toBeTruthy();
            });

        });
    });

    beforeEach(function () {
        module.apply(this, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            newDataValues = $injector.get('values.NewDataValues');
            routes = $injector.get('constants.Routes');
            railsServiceSpy = spyOnAngularService($injector.get('nsRailsService'), 'request', {readings: [
                {data: {age: 5}},
                {data: {age: 6}}
            ]});
            $timeout = $injector.get('$timeout');
            _.debounce = function (fn) {
                return function () {
                    $timeout(fn, 1);
                }
            };
            stripAngularKeysRequest = $injector.get('service.transformer.UniversalStripAngularKeysRequest');
            notifications = $injector.get('values.Notifications');
            controller = $injector.get('$controller')("controllers.DataAnalysisTable", {$scope: $scope});
        });
    });

    describe('Watchers', function () {
        describe('newDataValues.selectedLandfillOperator', function () {
            beforeEach(function () {
                newDataValues.selectedLandfillOperator = {id: 11};
            });

            it('Should do nothing if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect(railsServiceSpy).not.toHaveBeenCalled();
            });

            it('Should get the readings with the ids from the selections', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 11};
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 11
                    },
                    optional: {
                        'section_id': undefined,
                        'asset_id': undefined,
                        'start_date_time': null,
                        'end_date_time': null,
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with the startDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 17
                    },
                    optional: {
                        'section_id': undefined,
                        'asset_id': undefined,
                        'start_date_time': _epochDateFor($scope.startDateTime),
                        'end_date_time': null,
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with the endDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.endDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 17
                    },
                    optional: {
                        'section_id': undefined,
                        'asset_id': undefined,
                        'start_date_time': null,
                        'end_date_time': _epochDateFor($scope.endDateTime),
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with both the start and end dates if they are available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 19};
                $scope.startDateTime = new Date();
                $scope.endDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 19
                    },
                    optional: {
                        'asset_id': undefined,
                        'start_date_time': _epochDateFor($scope.startDateTime),
                        'end_date_time': _epochDateFor($scope.endDateTime),
                        'offset': $scope.page
                    }
                });
            });
        });

        describe('newDataValues.selectedSite', function () {
            it('Should do nothing if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect(railsServiceSpy).not.toHaveBeenCalled();
            });

            it('Should get the readings with the ids from the selections', function () {
                newDataValues.selectedSite = {id: 84};
                newDataValues.selectedMonitorClass = {id: 14};
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 84,
                        ':monitor_class_id': 14
                    },
                    optional: {
                        'asset_id': undefined,
                        'start_date_time': null,
                        'end_date_time': null,
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with the startDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 17
                    },
                    optional: {
                        'asset_id': undefined,
                        'start_date_time': _epochDateFor($scope.startDateTime),
                        'end_date_time': null,
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with the endDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.endDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 17
                    },
                    optional: {
                        'asset_id': undefined,
                        'start_date_time': null,
                        'end_date_time': _epochDateFor($scope.endDateTime),
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with both the start and end dates if they are available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.endDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 17
                    },
                    optional: {
                        'asset_id': undefined,
                        'start_date_time': _epochDateFor($scope.startDateTime),
                        'end_date_time': _epochDateFor($scope.endDateTime),
                        'offset': $scope.page
                    }
                });
            });
        });

        describe('newDataValues.selectedSection', function () {
            beforeEach(function () {
                newDataValues.selectedSection = {id: 78};
            });

            it('Should do nothing if there is no selectedSite', function () {
                newDataValues.selectedSite = null;
                $scope.$digest();
                expect(railsServiceSpy).not.toHaveBeenCalled();
            });

            it('Should get the readings with the ids from the selections', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 11};
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 11
                    },
                    optional: {
                        'section_id': 78,
                        'asset_id': undefined,
                        'start_date_time': null,
                        'end_date_time': null,
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with the startDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 12};
                $scope.startDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 12
                    },
                    optional: {
                        'section_id': 78,
                        'asset_id': undefined,
                        'start_date_time': _epochDateFor($scope.startDateTime),
                        'end_date_time': null,
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with the endDate if that is available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 9};
                $scope.endDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 9
                    },
                    optional: {
                        'section_id': 78,
                        'asset_id': undefined,
                        'start_date_time': null,
                        'end_date_time': _epochDateFor($scope.endDateTime),
                        'offset': $scope.page
                    }
                });
            });

            it('Should call with both the start and end dates if they are available', function () {
                newDataValues.selectedSite = {id: 45};
                newDataValues.selectedMonitorClass = {id: 17};
                $scope.startDateTime = new Date();
                $scope.endDateTime = new Date();
                $scope.$digest();
                $timeout.flush();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                    method: 'GET',
                    url: routes.ANALYSIS.READINGS,
                    params: {
                        ':site_id': 45,
                        ':monitor_class_id': 17
                    },
                    optional: {
                        'section_id': 78,
                        'asset_id': undefined,
                        'start_date_time': _epochDateFor($scope.startDateTime),
                        'end_date_time': _epochDateFor($scope.endDateTime),
                        'offset': $scope.page
                    }
                });
            });
        });

        describe('data', function () {
            it('Should not set filters if the data does not have length', function () {
                $scope.data = [];
                $scope.$digest();
                expect($scope.filters).toBeUndefined();
            });

            it('Should set the filters with the first item of the allData', function () {
                $scope.allData = [{name: 56, age: 38}];
                newDataValues.selectedMonitorClass = {id: 26};
                $scope.$digest();
                expect($scope.filters).toEqual([ { key : 'name', expression : '' }, { key : 'age', expression : '' } ]);
            });
        });

        describe('notifications.editSavedTrigger', function () {
            it('Should not call the rails service if there is no row under edit', function () {
                notifications.editSavedTrigger++;
                $scope.$digest();
                expect(railsServiceSpy).not.toHaveBeenCalled();
            });

            it('Should call the railsService when there is a row under edit', function () {
                $scope.rowUnderEdit = {id: 27, 'Date Time': '06/02/14, 16:07:00'};
                notifications.editSavedTrigger++;
                $scope.$digest();
                expect(railsServiceSpy).toHaveBeenCalledWith({
                        method: 'POST',
                        url: routes.ANALYSIS.UPDATE_READING,
                        params: {
                            ':id': $scope.rowUnderEdit.id
                        },
                        ignoreDataKeys: true,
                        data: $scope.rowUnderEdit,
                        transformRequest: stripAngularKeysRequest
                    })
            });
        });

        afterEach(function () {
            newDataValues.selectedLandfillOperator = null;
            newDataValues.selectedSite = null;
            newDataValues.selectedSection = null;
            newDataValues.selectedAsset = null;
        })
    });

    describe('Action Handlers', function () {

        describe('onPrev', function () {
            it('Should decrement the page value', function () {
                $scope.page = 2;
                $scope.onPrev();
                expect($scope.page).toEqual(1);
            });

            it('Should not be able to go below 1', function () {
                $scope.page = 1;
                $scope.onPrev();
                expect($scope.page).toEqual(1);
            });
        });

        describe('onNext', function () {

            beforeEach(function () {
                $scope.data = {length: 2700};
            });

            it('Should increment the page', function () {
                $scope.page = 0;
                $scope.onNext();
                expect($scope.page).toEqual(1);
            });
        });

        describe('onEditRow', function () {

            it('Should set the rowUnderEdit to the copy of the row passed in', function () {
                newDataValues.currentUser = {can_edit: true};
                var row = {$$hashKey: '25B'};
                $scope.onEditRow(row);
                expect($scope.rowUnderEdit).toEqual({});
                expect($scope.rowUnderEdit).not.toBe(row);
            });

            it('Should not do anything if the user does not have edit permission', function () {
                newDataValues.currentUser = {can_edit: false};
                $scope.onEditRow({$$hashKey: '25B'});
                expect($scope.rowUnderEdit).toBeNull();
            });

        });

    });

    describe('Initialization', function () {
        it('Should set the data property on scope to an empty array', function () {
            expect($scope.data).toEqual([]);
        });

        it('Should instantiate page to 1', function () {
            expect($scope.page).toEqual(1);
        });

        it('Should add newDataValues to the $scope', function () {
            expect($scope.newDataValues).toEqual(newDataValues);
        });

        it('Should set $scope.monitorPoints to an empty array', function () {
            expect($scope.monitorPoints).toEqual([]);
        });

        it('Should set startDateTime to null', function () {
            expect($scope.startDateTime).toBeNull();
        });

        it('Should set endDateTime to null', function () {
            expect($scope.endDateTime).toBeNull();
        });

        it('Should throw notifications on the $scope', function () {
            expect($scope.notifications).toEqual(notifications);
        });
    });
});