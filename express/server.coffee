# TODO:拆分代码，server太脏乱差了！
express = require('express')
morgan = require('morgan')
compression = require('compression')
bodyParser = require('body-parser')
swig = require('swig')
session = require('express-session')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
path = require 'path'

fse = require('fs-extra')
formidable = require('formidable')

Account = require './models/account'
Photo = require './models/photo'
Album = require './models/album'

connectMongo = require('./connect-mongo')
supportUpload = require './support-fineupload'

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
app.use('/photos', express.static('./photo-storage'))
app.use('/app', express.static('./app-build'))
app.use('/', express.static('./public'))

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
  if req.user
    res.send(req.user)
  else
    res.status(401).end()

router.post '/album', (req, res, next)->
  album = new Album
    user: req.user._id
    title: req.body.title
    description: req.body.description
  album.save (err)->
    if err
      console.log 'album save got a mistake'
    res.json(album)

# router.post '/upload', (req, res, next)->
#   # 这个路径？相对？绝对？
#   path = './photo-storage'
#   fse.ensureDir path, (err) ->
#     form = new (formidable.IncomingForm)
#     #Formidable uploads to operating systems tmp dir by default
#     form.uploadDir = path
#     #set upload directory
#     form.keepExtensions = true
#     #keep file extension
#     form.parse req, (err, fields, files) ->
#       # TODO: frontend file uploader using jQuery File Upload
#       console.log files.photo.path.replace(/^photo-storage/, '')
#       photo = new Photo(
#         user: req.user._id
#         # title: files.fileUploaded.name
#         description: 'description'
#         location: files.photo.path.replace(/^photo-storage/, ''))
#       photo.save (err) ->
#         if err
#           console.log 'photo save got a mistake'
#         res.json(photo)

app.use router

supportUpload app

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
