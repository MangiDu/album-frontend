mongoose = require('mongoose')
Schema = mongoose.Schema

Photo = new Schema(
  title: String
  description: String
  date:
    type: Date
    default: Date.now
  url: String
  thumbnail: String
)

Gallery = new Schema(
  user:
    type: Schema.Types.ObjectId
    ref: 'Account'
  title: String
  description: String
  date:
    type: Date
    default: Date.now
  photo_amount:
    type: Number
    default: 0
  cover: String
  photo: [Photo]
)
module.exports = mongoose.model('Gallery', Gallery)
