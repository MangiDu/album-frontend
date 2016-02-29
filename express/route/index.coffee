express = require('express')
passport = require('passport')

Account = require '../models/account'
Photo = require '../models/photo'
Album = require '../models/album'

router = express.Router()

router.get '/', (req, res)->
  res.render 'login'

router.post '/signup', (req, res) ->
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

router.get /^\/.+/, (req, res, next) ->
  if req.user && req.user._id
    next()
  else
    res.redirect '/'

router.get '/album', (req, res, next)->
  Album.find({user: req.user._id}, (err, docs)->
    if !err
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

module.exports = (app)->
  app.use router
