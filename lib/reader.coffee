fs    = require('fs')
url   = require('url')
http  = require('http')
https = require('https')

module.exports = class Reader
  messages =
    noSourceError: 'a valid source must be provided'
    httpStatusError: 'http status'

  source: null
  sourceType: null

  constructor: (@source) ->
    return unless @source
    switch
      when @_httpOptions(@source).protocol in ['http:', 'https:']
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

  getUrlStream: (options, callback = ->) ->
    options = @_httpOptions options
    client  = if options.protocol is 'https:' then https else http

    client.get options, (res) ->
      unless res.statusCode is 200
        err = new Error "#{messages.httpStatusError} #{res.statusCode}:
          #{http.STATUS_CODES[res.statusCode]}"
        callback err
        return
      callback null, res
    .on 'error', callback
    return

  _httpOptions: (options) ->
    options = url.parse options if typeof options is 'string'
    options
