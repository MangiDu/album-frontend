Photo = require '../../models/photo'

module.exports = (router)->
  return unless router

  router.get '/photo/:id', (req, res, next)->
    Photo.findOne({_id: req.params.id}, (err, doc)->
      res.send doc
    )

  router.put '/photo/:id', (req, res, next)->
    data = {
      title: req.body.title
      description: req.body.decription
    }
    Photo.findOneAndUpdate({_id: req.params.id}, data, {new: true}, (err, doc)->
      res.send doc
    )

  router.delete '/photo/:id', (req, res, next)->
    Photo.findOne {_id: req.params.id}, (err, doc)->
      doc.remove()
