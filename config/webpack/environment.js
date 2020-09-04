const { environment } = require('@rails/webpacker');
const { source_path: sourcePath } = require('@rails/webpacker/package/config');
const { join } = require('path');

// load jquery
// https://stackoverflow.com/questions/54905026/how-to-add-jquery-third-party-plugin-in-rails-6-webpacker/54906972#54906972
environment.loaders.append('jquery', {
  test: require.resolve('jquery'),
  use: [{
    loader: 'expose-loader',
    options: '$',
  }, {
    loader: 'expose-loader',
    options: 'jQuery',
  }],
});  

const erbLoader = {
  test: /\.erb$/,
  enforce: 'pre',
  loader: 'rails-erb-loader'
};

const myFileOptions = {
    name(file) {
        if (file.includes(sourcePath)) {
            return 'media/[path][name].[ext]'
        }
        return 'media/[folder]/[name].[ext]'
    },
    context: join(sourcePath)
};

const fileLoader = environment.loaders.get('file').use.find(el => el.loader === 'file-loader');
fileLoader.options = myFileOptions;

environment.loaders.prepend('erb', erbLoader);
module.exports = environment;
