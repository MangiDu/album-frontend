'use strict';

var path = require('path');

var nodeModulesPath = path.join(__dirname, '/node_modules/');

module.exports = {
  output: {
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      { test: /\.css$/, loader: 'style!css' }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.css', '.html'],
    alias: {
      jquery: path.join(nodeModulesPath, 'jquery/dist/jquery')
    }
  }
};
