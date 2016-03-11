express = require('express')
router = express.Router()

# TODO: ORM
router.get '/', (req, res)->
  res.render 'login'

# 注册登陆登出
require('./userAuthority') router
# API
require('./api/user') router
require('./api/album') router
require('./api/photo') router
# 上传照片
require('./support-fineupload')(router)

# 屏蔽掉其他未定义的路由
router.get /^\/.+/, (req, res, next) ->
  if req.user && req.user._id
    res.redirect '/app'
  else
    res.redirect '/'

module.exports = (app)->
  app.use router
