config = require '../config'
_ = require 'underscore'

Util = {
  redirectTo: (route, options={})->
    _.defaults options, {trigger: true}
    unless config.router
      console.warn 'no config.router'
      return
    config.router.navigate route, options
}

module.exports = Util
