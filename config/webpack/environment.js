const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

// Required for vue-loader v15
const VueLoaderPlugin = require('vue-loader/lib/plugin')
environment.plugins.append(
  'VueLoaderPlugin',
  new VueLoaderPlugin()
)

environment.loaders.append('vue', vue)
module.exports = environment
