fs      = require('fs')
url     = require('url')
http    = require('http')
through = require('through')
phantom = require('phantom')

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

  getStream: (cb = ->) ->
    switch @sourceType
      when 'file'
        @getFileStream @source, cb
      when 'url'
        @getUrlStream @source, cb
      else
        cb new Error(messages.noSourceError)
    return

  getFileStream: (source, cb = ->) ->
    cb null, fs.createReadStream(source)
    return

  getUrlStream: (source, cb = ->) ->
    phantom.create
      parameters:
        'ignore-ssl-errors': 'yes'
    , (ph) =>
      ph.createPage (page) =>
        page.set 'onResourceReceived', @_onPageResourceReceived.bind(this, cb)
        page.open source, @_onPageOpen.bind(this, cb, ph, page)

  _onPageResourceReceived: (cb, res) ->
    if res.stage is 'end' and res.status isnt 200
      err = new Error "#{messages.httpStatusError} #{res.status}:
        #{http.STATUS_CODES[res.status]}"
      cb err

  _onPageOpen: (cb, ph, page, status) ->
    return if status isnt 'success'
    thru = through (data) -> @emit 'data', data
    cb null, thru

    page.evaluate (-> document.body.innerHTML), (content) ->
      thru.end content
      ph.exit()

  _httpOptions: (options) ->
    options = url.parse options if typeof options is 'string'
    options
