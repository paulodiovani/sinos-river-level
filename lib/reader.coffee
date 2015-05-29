fs  = require('fs')
url = require('url')

module.exports = class Reader
  messages =
    noSourceError: 'a valid source must be provided'

  source: null
  sourceType: null

  constructor: (@source) ->
    return unless @source
    switch
      when url.parse(@source).protocol in ['http:', 'https:']
        @sourceType = 'url'
      when fs.existsSync @source
        @sourceType = 'file'
      else
        @source = null

  getStream: ->
    switch @sourceType
      when 'file'
        @getFileStream @source
      when 'url'
        @getUrlStream @source
      else
        throw new Error(messages.noSourceError)

  getFileStream: (path) ->
    fs.createReadStream path
