fs = require('fs')

module.exports = class Reader
  getFileStream: (path) ->
    fs.createReadStream path
