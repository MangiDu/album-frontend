Marionette = require 'backbone.marionette'
_ = require 'underscore'
CONTROLLERS_MAP = require './controllers-map'
Util = require './util/util'

ROUTERS = {}
CONTROLLERS = {}
for k,v of CONTROLLERS_MAP
  ROUTERS[k] = k
  CONTROLLERS[k] = require v

CONTROLLERS.other = ->
  Util.redirectTo '/home'

Router = Marionette.AppRouter.extend({
  initialize: ()->
    _.extend @options, {
      appRoutes: _.extend ROUTERS, {
        '*other': 'other'
      }
      controller: CONTROLLERS
    }
})

module.exports = Router
