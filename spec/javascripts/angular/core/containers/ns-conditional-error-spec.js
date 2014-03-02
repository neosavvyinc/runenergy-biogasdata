describe("nsConditionalError", function () {
    var $rootScope,
        $scope,
        nsConditions,
        nsConditionErrors,
        el,
        $body = $('body'),
        simpleHtml = '<ns-conditional-error error="someVar"></ns-conditional-error>';

    beforeEach(function () {
        module.apply(module, RunEnergy.Dashboard.Dependencies);

        inject(function ($injector, $compile) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            nsConditions = $injector.get('nsConditions');
            nsConditionErrors = $injector.get('nsConditionErrors');
            el = $compile(angular.element(simpleHtml))($scope);
        });

        nsConditionErrors.error = "";

        $body.append(el);
        $rootScope.$digest();
    });

    var returnsFalse, returnsTrue, returnsArgs;

    beforeEach(function () {
        returnsFalse = function () {
            return false;
        };
        returnsTrue = function () {
            return true;
        };
        returnsArgs = function () {
            var val = true;
            for (var i = 0; i < arguments.length; i++) {
                val = val && arguments[i];
            }
            return val;
        }
    });

    afterEach(function () {
        $body.empty();
    });



    describe('nsConditions', function () {

        describe('errors', function () {
            it('Should return the nsConditions object', function () {
                expect(nsConditions.errors("This", "That", "The Other")).toEqual(nsConditions);
            });

            it('Should be able to chain with valueOf', function () {
                expect(nsConditions.errors("This").valueOf()).toBeTruthy();
            });

            it('Should be able to chain with other methods', function () {
                expect(nsConditions.errors("This").anyBlank().valueOf()).toBeFalsy();
            });
        });

        describe('valueOf', function () {
            it('Should return true by default', function () {
                expect(nsConditions.valueOf()).toBeTruthy();
            });
        });

        describe('anyBlank', function () {

            it('Should return false by default', function () {
                expect(nsConditions.anyBlank().valueOf()).toBeFalsy();
            });

            it('Should return true if all arguments are blank', function () {
                expect(nsConditions.anyBlank(undefined, null, "").valueOf()).toBeTruthy();
            });

            it('Should return true if any arguments are blank', function () {
                expect(nsConditions.anyBlank('Harry', null, 'George').valueOf()).toBeTruthy();
            });

            it('Should return false if all arguments have a value', function () {
                expect(nsConditions.anyBlank(55, 56, "Tom").valueOf()).toBeFalsy();
            });

            describe('notAnyBlank', function () {

                it('Should return true by default', function () {
                    expect(nsConditions.notAnyBlank().valueOf()).toBeTruthy();
                });

                it('Should return false if any are blank', function () {
                    expect(nsConditions.notAnyBlank(null, 50).valueOf()).toBeFalsy();
                });

                it('Should return false if all are blank', function () {
                    expect(nsConditions.notAnyBlank("", " ", undefined).valueOf()).toBeFalsy();
                });

                it('Should return true if all are filled', function () {
                    expect(nsConditions.notAnyBlank(0, "Hello", {}).valueOf()).toBeTruthy();
                });

            });

        });

        describe('execute', function () {

            it('Should return true with no arguments', function () {
                expect(nsConditions.execute().valueOf()).toBeTruthy();

            });

            it('Should throw an error if the number of arguments is uneven', function () {
                expect(function () {
                    nsConditions.execute(returnsTrue)
                }).toThrow();
            });

            it('Should return false if all methods return false', function () {
                expect(nsConditions.execute(returnsFalse, [], returnsArgs, [true, true, false]).valueOf()).toBeFalsy();
            });

            it('Should return false if any method returns false', function () {
                expect(nsConditions.execute(returnsTrue, [], returnsArgs, [true, true, false]).valueOf()).toBeFalsy();
            });

            it('Should return true if all methods return true', function () {
                expect(nsConditions.execute(returnsTrue, [], returnsArgs, [true, true]).valueOf()).toBeTruthy();
            });

            describe('notExecute', function () {

                it('Should throw an error if the number of arguments is uneven', function () {
                    expect(function () {
                        nsConditions.notExecute(returnsTrue)
                    }).toThrow();
                });

                it('Should return false by default', function () {
                    expect(nsConditions.notExecute().valueOf()).toBeFalsy();
                });

                it('Should return true if any method returns false', function () {
                    expect(nsConditions.notExecute(returnsFalse, [], returnsTrue, []).valueOf()).toBeTruthy();
                });

                it('Should return true if all methods return false', function () {
                    expect(nsConditions.notExecute(returnsFalse, [], returnsArgs, [false, true, false]).valueOf()).toBeTruthy();
                });

                it('Should return false if all methods returns true', function () {
                    expect(nsConditions.notExecute(returnsTrue, [], returnsArgs, [true]).valueOf()).toBeFalsy();
                });

            });

        });

    });

    describe('nsConditionalError', function () {

        it('Should set the error in the container if a condition fails', function () {
            nsConditions
                .errors("You must provide a name.", "You must provide an age.")
                .notAnyBlank("Mike", null)
                .valueOf()
            $rootScope.$digest();
            expect(el.text()).toEqual("You must provide an age.");
        });

        it('Should set no error if the condition passed', function () {
            nsConditions
                .errors("You must provide a name.", "You must provide an age.")
                .notAnyBlank("Mike", 78)
                .valueOf()
            $rootScope.$digest();
            expect(el.text()).toEqual("");
        });

        it('Should clear the error if a condition passes after it fails', function () {
            nsConditions
                .errors("You must provide a name.", "You must provide an age.")
                .notAnyBlank(undefined, 45)
                .valueOf();
            $rootScope.$digest();
            expect(el.text()).toEqual("You must provide a name.");

            nsConditions
                .errors("You must provide a name.", "You must provide an age.")
                .notAnyBlank("Terrence", 45)
                .valueOf();
            $rootScope.$digest();
            expect(el.text()).toEqual("");
        });

        it('Should be able to change the error if a condition failure changes the error', function () {
            nsConditions
                .errors("You must provide a name.", "You must provide an age.")
                .notAnyBlank(undefined, 45)
                .valueOf();
            $rootScope.$digest();
            expect(el.text()).toEqual("You must provide a name.");

            nsConditions
                .errors("You must provide a name.", "Stone Dead Forever")
                .execute(returnsTrue, [], returnsFalse, [])
                .valueOf();
            $rootScope.$digest();
            expect(el.text()).toEqual("Stone Dead Forever");
        });

    });
});