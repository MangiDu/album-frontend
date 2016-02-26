express = require 'express'
swig = require 'swig'
path = require 'path'

connectMongo = require './connect-mongo'

app = express()

# 需要一个常量池来存储常用的？
app.engine 'html', swig.renderFile
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'html'

require('./config') app
require('./route') app

listen = ->
  server = app.listen 3030, ->
    console.log 'App listening at port:' + server.address().port

connectMongo().once 'open', listen
