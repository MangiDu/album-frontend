mongoose = require('mongoose')
Schema = mongoose.Schema
Photo = new Schema(
  user:
    type: Schema.Types.ObjectId
    ref: 'Account'
  album:
    type: Schema.Types.ObjectId
    ref: 'Album'
  title: String
  description: String
  date:
    type: Date
    default: Date.now
  url: String
  thumbnail: String
)

Photo.statics.delete = (id, cb)->
  this.findOne {_id: id}, (err, doc)->
    if err
      return
    doc.remove(cb)

module.exports = mongoose.model('Photo', Photo)
