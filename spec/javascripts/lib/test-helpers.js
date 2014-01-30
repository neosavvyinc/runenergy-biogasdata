//Override for omniture purposes
var s = {tl: function () {
}, t: function () {
}};

spyOnAngularService = function (service, methodName, result) {
    return spyOn(service, methodName).andReturn({then: function (fn) {
        fn(result);
    }});
};

spyOnChainedPromise = function (object, method, results) {
    var index = 0;
    function _chainedPromise(fn) {
        fn(results[Math.min(index++, results.length - 1)]);
        return {then: _chainedPromise};
    };
    return spyOn(object, method).andReturn({then: _chainedPromise});
};

domControllerAndScope = function (name, parentScope) {
    var scope;
    inject(function ($injector, $compile) {
        $compile(angular.element('<p ng-controller="' + name + ' as ctrl"></p>'))(parentScope);
        scope = parentScope.$$childTail;
    });
    return {scope: scope, controller: scope['ctrl']};
};