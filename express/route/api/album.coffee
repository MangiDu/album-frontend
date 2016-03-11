Album = require '../../models/album'
Photo = require '../../models/photo'

_ = require 'underscore'

module.exports = (router)->
  return unless router

  router.get '/album', (req, res, next)->
    Album.find({user: req.user._id}, (err, docs)->
      if !err
        res.send docs
      else
        console.log(err)
    )

  router.get '/album/:id', (req, res, next)->
    Album.findOne({_id: req.params.id}, (err, doc)->
      res.send doc
    )

  router.delete '/album/:id', (req, res, next)->
    Photo.find({album: req.params.id}, (err, docs)->
      _.each docs, (doc)->
        doc.remove()
    )
    Album.findOne({_id: req.params.id}, (err, doc)->
      doc.remove()
    )

  router.put '/album/:id', (req, res, next)->
    data =
      title: req.body.title
      description: req.body.description

    Album.findOneAndUpdate({_id: req.params.id}, data, {new: true}, (err, doc)->
      res.send doc
    )

  # TODO:photo应该是album的subdocument
  router.get '/album-brief', (req, res, next)->
    Album.find({user: req.user._id}, '_id title', (err, docs)->
      if !err
        # console.log docs
        res.send docs
      else
        console.log(err)
    )

  router.get '/album-detail', (req, res, next)->
    Photo.find({user: req.user._id, album: req.query.album}, (err, docs)->
      if !err
        # console.log docs
        res.send docs
      else
        console.log err
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
