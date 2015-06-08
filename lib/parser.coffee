trumpet = require('trumpet')

module.exports = class Parser
  constructor: (@htmlStream) ->

  getYears: (cb = ->) ->
    tr     = trumpet()
    result = years: []

    tr.selectAll '#sheet-menu > [id^=sheet-button] > a', (el) ->
      el.createReadStream().on 'data', (data) ->
        result.years.push data.toString()

    tr.on 'error', cb
    tr.on 'end', ->
      cb null, result

    @htmlStream.pipe tr
