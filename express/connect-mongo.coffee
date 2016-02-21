mongoose = require('mongoose')

module.exports = ->
  mongoose.connect('mongodb://localhost/album_database').connection
