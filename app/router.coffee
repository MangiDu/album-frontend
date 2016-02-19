Marionette = require 'backbone.marionette'
_ = require 'underscore'
CTL_MAP = require './controllers-map'

RT = {}
CTL = {}
for k,v of CTL_MAP
  RT[k] = k
  CTL[k] = require v

Router = Marionette.AppRouter.extend({
  initialize: ()->
    _.extend @options, {
      appRoutes: _.extend RT, {
        # '*other': 'other'
      }
      controller: _.extend Marionette.Object.extend({}), CTL
    }
})

module.exports = Router
