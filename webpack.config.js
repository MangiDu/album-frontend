'use strict';

var webpack = require('webpack');
var path = require('path');

module.exports = {
  entry: {
    bundle: './compile/main.js',
    vendors: [
      'jquery',
      'bootstrap',
      'swig',
      'underscore',
      'backbone',
      'backbone.marionette'
    ]
  },
  output: {
    filename: '[name].js'
  },
  module: {
    loaders: [{
      test: /\.css$/,
      loader: 'style!css'
    }, {
      test: /\.html$/,
      loader: 'html'
    }, {
      test: /\.(woff|woff2|eot|ttf|svg)(\?.*$|$)/,
      loader: 'url-loader?importLoaders=1&limit=1000&name=./fonts/[name].[ext]'
    }, {
      test: /\.(png|jpeg|gif)$/,
      loader: 'url-loader?limit=8192',
    }]
  },
  resolve: {
    extensions: ['', '.js', '.css', '.html'],
    alias: {
      swig: path.join(__dirname + '/node_modules/swig/dist/swig'),
      marionette: 'backbone.marionette'
    }
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery'
    }),
    new webpack.optimize.CommonsChunkPlugin('vendors', 'vendors.js')
  ]
};
