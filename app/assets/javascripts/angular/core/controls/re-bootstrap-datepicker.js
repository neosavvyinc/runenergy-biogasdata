RunEnergy.Dashboard.Directives
    .directive('reBootstrapDatepicker', function () {
        return {
            restrict: 'E',
            replace: true,
            template: '<div class="re-bootstrap-datepicker input-append date" data-date="12-02-2012" data-date-format="dd-mm-yyyy"><input class="span2" type="text" value="12-02-2012" readonly><span class="add-on"><i class="icon-calendar"></i></span></div>',
            scope: {
                value: "="
            },
            link: function (scope, element, attrs) {
                $(element[0]).datepicker();
            }
        }
    });