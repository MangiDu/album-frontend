express = require('express')
morgan = require('morgan')
compression = require('compression')
bodyParser = require('body-parser')
swig = require('swig')
session = require('express-session')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
path = require 'path'

Account = require '../models/account'

module.exports = (app)->
  app.use morgan('dev')
  app.use compression()
  app.use bodyParser.urlencoded(extended: false)
  app.use bodyParser.json()
  app.use session(
    secret: 'album ol'
    resave: false
    saveUninitialized: false)
  app.use passport.initialize()
  app.use passport.session()

  # 为啥不是../public?虽然当下能运行
  app.use('/photo-storage', express.static('./photo-storage'))
  app.use('/app', express.static('./app-build'))
  app.use('/', express.static('./public'))
  app.use('/vendors', express.static('./vendors'))

  passport.use new LocalStrategy(Account.authenticate())
  passport.serializeUser Account.serializeUser()
  passport.deserializeUser Account.deserializeUser()
