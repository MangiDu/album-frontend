config = require '../config'

Util = {
  redirectTo: (route, options={trigger: true})->
    unless config.router
      console.warn 'no config.router'
      return
    config.router.navigate route, options
}

module.exports = Util
