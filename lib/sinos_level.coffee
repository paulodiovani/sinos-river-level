Reader = require('./reader')
Parser = require('./parser')

class SinosLevel
  # coffeelint: disable=max_line_length
  DEFAULT_SOURCE = 'https://docs.google.com/spreadsheet/pub?key=0AkXSgrDXAQJjdG1JZVFDcEpLQU5JY2dLTWZBcW9jVEE&gid=9'
  # coffeelint: enable=max_line_length

  messages =
    noParserError: 'parser is not defined'

  source: null
  reader: null
  parser: null

  constructor: (@source = DEFAULT_SOURCE) ->

  init: (cb = ->) ->
    @reader = new Reader @source
    @reader.getStream (err, stream) =>
      return cb err if err?
      @parser = new Parser stream
      cb null
    return

  getYears: (cb = ->) ->
    throw new Error messages.noParserError unless @parser?
    @parser.getYears cb

module.exports = SinosLevel
module.exports.Reader = Reader
module.exports.Parser = Parser
