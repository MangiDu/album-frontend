Marionette = require 'marionette'

class BaseView extends Marionette.ItemView.extend()

  render: ->
    super
    # drop extra div wrapper when render
    @$el = @$el.children()
    @$el.unwrap()
    @setElement(@$el)

module.exports = BaseView
