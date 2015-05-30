trumpet = require('trumpet')

module.exports = class Parser
  constructor: (@htmlStream) ->

  getYears: (callback = ->) ->
    tr     = trumpet()
    result = years: []

    tr.selectAll '#sheet-menu > div > a', (el) ->
      el.createReadStream().on 'data', (data) ->
        result.years.push data.toString()

    tr.on 'error', callback
    tr.on 'end', ->
      callback null, result

    @htmlStream.pipe tr
