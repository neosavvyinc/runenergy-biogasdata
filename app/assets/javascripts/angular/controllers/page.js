RunEnergy.Dashboard.Controllers.controller('controllers.PageController',
    ['$scope', '$rootScope', 'values.DashboardPageData',
        function ($scope, $rootScope, dashboardPageData) {

            //ACTION HANDLERS
            $scope.onNext = function() {
                dashboardPageData.page++;
            };

            $scope.onPrevious = function() {
              if (dashboardPageData > 0) {
                  dashboardPageData.page--;
              }
            };

            //INITIALIZATION
            $scope.dashboardPageData = dashboardPageData;


        }]);