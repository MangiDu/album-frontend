Marionette = require 'backbone.marionette'
_ = require 'underscore'
CONTROLLERS_MAP = require './controllers-map'

ROUTERS = {}
CONTROLLERS = {}
for k,v of CONTROLLERS_MAP
  ROUTERS[k] = k
  CONTROLLERS[k] = require v

Router = Marionette.AppRouter.extend({
  initialize: ()->
    _.extend @options, {
      appRoutes: _.extend ROUTERS, {
        # '*other': 'other'
      }
      controller: _.extend Marionette.Object.extend({}), CONTROLLERS
    }
})

module.exports = Router
