Marionette = require 'backbone.marionette'

BaseController = Marionette.Object.extend

Router = Marionette.AppRouter.extend
  appRoutes:
    'login': 'login'
    '*other': 'login'
  controller: new BaseController

module.exports = Router
