passport = require('passport')

Account = require '../models/account'

module.exports = (router)->
  unless router
    return

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
