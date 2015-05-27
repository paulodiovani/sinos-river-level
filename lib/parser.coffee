trumpet = require('trumpet')

module.exports = class Parser
  constructor: (@htmlStream) ->

  getYears: (callback) ->
    tr    = trumpet()
    years = []

    tr.selectAll '#sheet-menu > div > a', (el) ->
      el.createReadStream().on 'data', (data) ->
        years.push data.toString()

    tr.on 'error', callback
    tr.on 'end', ->
      callback null, years

    @htmlStream.pipe tr
