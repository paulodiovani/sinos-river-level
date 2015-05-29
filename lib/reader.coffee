fs   = require('fs')
url  = require('url')
http = require('http')

module.exports = class Reader
  messages =
    noSourceError: 'a valid source must be provided'
    httpStatusError: 'http status'

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

  getStream: (callback = ->) ->
    switch @sourceType
      when 'file'
        @getFileStream @source, callback
      when 'url'
        @getUrlStream @source, callback
      else
        callback new Error(messages.noSourceError)
    return

  getFileStream: (path, callback = ->) ->
    callback null, fs.createReadStream(path)
    return

  getUrlStream: (url, callback = ->) ->
    http.get url, (res) ->
      unless res.statusCode is 200
        err = new Error "#{messages.httpStatusError} #{res.statusCode}:
          #{http.STATUS_CODES[res.statusCode]}"
        callback err
        return
      callback null, res
    .on 'error', callback
    return
