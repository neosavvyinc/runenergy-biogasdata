//Override for omniture purposes
var s = {tl: function () {
}, t: function () {
}};

spyOnAngularService = function (service, methodName, result) {
    return spyOn(service, methodName).andReturn({then: function (fn) {
        fn(result);
    }});
};

domControllerAndScope = function (name, parentScope) {
    var scope;
    inject(function ($injector, $compile) {
        $compile(angular.element('<p ng-controller="' + name + ' as ctrl"></p>'))(parentScope);
        scope = parentScope.$$childTail;
    });
    return {scope: scope, controller: scope['ctrl']};
};