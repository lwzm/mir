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
        var N = 10;
        var P = 100;
        var i, j;
        var page = $routeParams.page || 1;
        var pages = [];

        for (i = 1; i < data[data.length - 1] / P + 1; i++) {
            pages.push(i);
        }

        var src_pre = $location.path() + "/";
        var pics_list = [];
        for (i = (page - 1) * P; i < page * P; i += N) {
            var pics = [];
            for (j = i; j < i + N; j++) {
                if (data.indexOf(j) != -1) {
                    pics.push(src_pre + j + ".bmp");
                }
            }
            pics_list.push(pics);
        }

        $scope.pics_list = pics_list;
        $scope.pages = pages;
        $scope.href_pre = "#" + $location.path() + "?page=";
    });
})
