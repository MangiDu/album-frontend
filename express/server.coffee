express = require('express')
morgan = require('morgan')
compression = require('compression')
bodyParser = require('body-parser')
swig = require('swig')
session = require('express-session')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
path = require 'path'

Account = require './models/account'
connectMongo = require('./connect-mongo')

app = express()

app.engine('html', swig.renderFile)
app.set('views', path.join __dirname, 'views')
app.set('view engine', 'html')
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

# setRoutes app
router = express.Router()
router.get '/', (req, res) ->
  res.render 'login'

# 为啥不是../public?虽然当下能运行
app.use('/app', express.static('./public'))

# router.get '/register', (req, res) ->
#   res.render 'register', {}

router.post '/signup', (req, res) ->
  console.log 'signup'
  Account.register new Account(username: req.body.username), req.body.password, (err, account) ->
    if err
      return res.render('err', account: account)
    passport.authenticate('local') req, res, ->
      res.redirect '/app'

router.post '/signin', passport.authenticate('local'), (req, res, next) ->
  req.session.save (err) ->
    if err
      return next(err)
    res.redirect '/app'

router.get '/signout', (req, res, next) ->
  req.logout()
  req.session.save (err) ->
    if err
      return next(err)
    res.redirect '/'

router.get '/api/user', (req, res, next)->
  if res.user
    res.send(req.user)
  else
    res.status(401).end()

app.use router

Account = require('./models/account')
passport.use new LocalStrategy(Account.authenticate())
passport.serializeUser Account.serializeUser()
passport.deserializeUser Account.deserializeUser()

listen = ->
  server = app.listen(3030, ->
    port = server.address().port

    console.log('App listening at port:' + port)
  )

connectMongo().once('open', listen)

# server = app.listen(3030, ()->
#   host = server.address().address
#   port = server.address().port
#
#   console.log('Example app listening at http://%s:%s', host, port)
# )
