function SendViewer (innerHtml) {
  $('#viewer').append(innerHtml);
}

function SendEditor (innerHtml) {
  
}

addEventListener('app-ready', function(e){
  var fs   = require('fs'),
      path = require('path'),
      cwd  = process.cwd(),
      ul   = document.getElementById('paths');

  var showdown  = require('showdown'),
      converter = new showdown.Converter();

  var asViewer = process.argv && process.argv.length > 2;
  var fileName = process.argv[2];

  if (asViewer) {
    fs.exists(fileName, function (exists) {
      if (exists) {
        fs.readFile(fileName, function (err, data) {
          if (err) throw err;
          try {
            var html = converter.makeHtml(''+data);
            SendViewer(html);
          } catch (ex) {
            console.log(ex);
          }
        });
      }
    });
  }
  else
    SendEditor('');

  window.dispatchEvent(new Event('app-done'));
});