require '../node_modules/bootstrap/dist/css/bootstrap'
require './app-style'

AlbumApp = require './application/app'

app = new AlbumApp()

app.start()
