angular.module('app', [])
  .controller('appController', function($scope, $sce) {
    $scope.filename = '';
    $scope.fullname = '';
    $scope.editmode = false;
    $scope.mdtext = '';
    $scope.htmltext = '';
    $scope.mdtextcol = '';
    $scope.htmltextcol = 'col-xs-12';

    var fs = null;
    var converter = null;
    var originalData = null;

    function changecolumns() {
      if ($scope.editmode) {
        $scope.mdtextcol = 'col-xs-6';
        $scope.htmltextcol = 'col-xs-6';
      } else {
        $scope.mdtextcol = '';
        $scope.htmltextcol = 'col-xs-12';
      }
    };

    function invertEdit () {
      $scope.editmode = !$scope.editmode;
      changecolumns();
    }

    $scope.edit = function() {
      invertEdit();
    };

    $scope.save = function() {
      fs.writeFile($scope.fullname, $scope.mdtext, function(err) {
        if (err) throw err;
        $scope.$apply(function() {
          invertEdit();
        });
      });
    };

    $scope.cancel = function() {
      $scope.mdtext = originalData;
      $scope.htmltext = $sce.trustAsHtml(converter.makeHtml($scope.mdtext));
      invertEdit();
    };

    $scope.textchange = function() {
      $scope.htmltext = $sce.trustAsHtml(converter.makeHtml($scope.mdtext));
    };

    addEventListener('app-ready', function(e){
      fs   = require('fs');
      var path = require('path');
      var showdown  = require('showdown');
      converter = new showdown.Converter();

      var asViewer = process.argv && process.argv.length > 2;
      var fileName = process.argv[2];
      $scope.$apply(function() {
        $scope.fullname = fileName;
        $scope.filename = path.basename(fileName);
      });

      if (asViewer) {
        fs.exists(fileName, function (exists) {
          if (exists) {
            fs.readFile(fileName, function (err, data) {
              if (err) throw err;
              $scope.$apply(function() {
                originalData = ''+data;
                $scope.mdtext = originalData;
                $scope.htmltext = $sce.trustAsHtml(converter.makeHtml($scope.mdtext));
              });
            });
          }
        });
      }
      else
        SendEditor('');

      window.dispatchEvent(new Event('app-done'));
    });
  });

