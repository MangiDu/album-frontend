'use strict';

var webpack = require('webpack');

module.exports = {
  entry: {
    bundle: './build/script/main.js',
    vendors: ['jquery', 'bootstrap']
  },
  output: {
    filename: '[name].js'
  },
  module: {
    loaders: [
      {test: /\.css$/, loader: 'style!css'},
      {
        test: /\.(woff|woff2|eot|ttf|svg)(\?.*$|$)/,
        loader: 'url-loader?importLoaders=1&limit=1000&name=./fonts/[name].[ext]'
      },
    ]
  },
  resolve: {
    extensions: ['', '.js', '.css', '.html'],
    alias: {
      jQuery: 'jquery'
    }
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    }),
    new webpack.optimize.CommonsChunkPlugin('vendors', 'vendors.js')
  ]
};
