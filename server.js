var express = require('express');
var app = express();

app.use(express.static('./public'));

app.get('/api/user', function(req, res, next){
  res.send({username: 'Danny'})
});

var server = app.listen(3030, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
