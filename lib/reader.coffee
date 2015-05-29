fs = require('fs')

module.exports = class Reader
  messages =
    noSourceError: 'a valid source must be provided'

  source: null
  sourceType: null

  getStream: ->
    throw new Error(messages.noSourceError) if @source is null

  getFileStream: (path) ->
    fs.createReadStream path
