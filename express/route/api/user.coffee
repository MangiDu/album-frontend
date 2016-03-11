module.exports = (router)->
  return unless router
  
  router.get '/api/user', (req, res, next)->
    if req.user
      res.send(req.user)
    else
      res.status(401).end()
