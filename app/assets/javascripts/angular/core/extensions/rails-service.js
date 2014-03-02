RunEnergy.Dashboard.Services.service('nsRailsService',
    ['nsServiceExtensions',
        function (nsServiceExtensions) {
            var RE_A = /\W+/g;
            var RE_B = /([a-z\d])([A-Z])/g;
            var _isBlank = Neosavvy.Core.Utils.StringUtils.isBlank;

            function _keysToSnakeCase(obj, nObj) {
                nObj = nObj || {};
                for (var key in obj) {
                    var newKey = key.replace(RE_A, '_').replace(RE_B, '$1_$2').toLowerCase();
                    if (obj[key] &&
                        typeof obj[key] === 'object' &&
                        obj[key].constructor.toString().indexOf('Array') === -1) {
                        nObj[newKey] = {};
                        _keysToSnakeCase(obj[key], nObj[newKey]);
                    } else {
                        nObj[newKey] = obj[key];
                    }
                }
                return nObj;
            }


            this.request = function (options) {
                if (options && typeof options === 'object') {
                    var builder = new Neosavvy.Core.Builders.RequestUrlBuilder(options.url);
                    if (options.params && typeof options.params === 'object') {
                        builder.paramReplace(options.params);
                        delete options.params;
                    }
                    if (options.optional && typeof options.optional === 'object') {
                        builder.addParam(_.omit(options.optional, function (val) {
                            return _isBlank(val);
                        }));
                        delete options.optional;
                    }
                    options.url = builder.build();
                    if (options.data && typeof options.data === 'object') {
                        if (!options.ignoreDataKeys) {
                            options.data = _keysToSnakeCase(options.data);
                        }
                    }
                    return nsServiceExtensions.request(options);
                } else {
                    throw "Do not call a rails service without options, you know better.";
                }
            };
        }]);