mongoose = require('mongoose')
Schema = mongoose.Schema
Album = new Schema(
  user:
    type: Schema.Types.ObjectId
    ref: 'Account'
  title: String
  description: String
  date:
    type: Date
    default: Date.now
)
module.exports = mongoose.model('Album', Album)
