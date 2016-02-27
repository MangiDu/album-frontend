express = require('express')
passport = require('passport')
fse = require('fs-extra')
# formidable = require('formidable')

Account = require '../models/account'
Photo = require '../models/photo'
Album = require '../models/album'

router = express.Router()
router.get '/', (req, res) ->
  res.render 'login'

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

router.get '/album', (req, res, next)->
  Album.find({}, (err, docs)->
    if !err
      # console.log(docs)
      res.send docs
    else
      console.log(err)
  )

router.post '/album', (req, res, next)->
  album = new Album
    user: req.user._id
    title: req.body.title
    description: req.body.description
  album.save (err)->
    if err
      console.log 'album save got a mistake'
    res.json(album)

require('./support-fineupload')(router)

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

module.exports = (app)->
  app.use router
