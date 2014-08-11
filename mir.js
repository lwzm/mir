angular.module("mir", ["ngRoute", ], function($routeProvider) {
    $routeProvider.when("/", {
        templateUrl: "dirs.html", controller: "Dirs",
    }).when("/:dir", {
        templateUrl: "pics.html", controller: "Pics",
    });
}).controller("Dirs", function($scope, $http) {
    $http.get("dirs.json").success(function(data) {
        $scope.dirs = data;
    });
}).controller("Pics", function($scope, $http, $location, $routeParams) {
    $http.get($routeParams.dir + ".json").success(function(data) {
        //console.log($routeParams);
        //console.log($location.path());
        var n = 10;
        var page = $routeParams.page || 1;
        var pages = [];
        var _len = (data.length + n - 1) / n;
        for (var _p = 1; _p < _len; _p++) {
            pages.push(_p);
        }
        $scope.pics = data.slice(n * (page - 1), n * page);
        $scope.pages = pages;
        $scope.href_pre = "#" + $location.path() + "?page=";
        $scope.src_pre = $location.path() + "/";
    });
})
