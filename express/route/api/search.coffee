Photo = require '../../models/photo'
_ = require 'underscore'

module.exports = (router)->
  return unless router

  router.get '/search', (req, res, next)->
    console.log 'req.query'
    console.log req.query
    Photo.find({user: req.user._id, title: new RegExp(req.query.title, 'i')}, (err, docs)->
      res.send docs
    )
