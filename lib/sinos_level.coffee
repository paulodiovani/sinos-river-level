Reader = require('./reader')
Parser = require('./parser')

class SinosLevel
  # coffeelint: disable=max_line_length
  DEFAULT_SOURCE = 'https://docs.google.com/spreadsheet/pub?key=0AkXSgrDXAQJjdG1JZVFDcEpLQU5JY2dLTWZBcW9jVEE&gid=9'
  # coffeelint: enable=max_line_length

  constructor: (@source = DEFAULT_SOURCE) ->

  init: (callback = ->) ->
    @reader = new Reader @source
    @reader.getStream (err, stream) =>
      return callback err if err?
      @parser = new Parser stream
      callback null
    return

module.exports = SinosLevel
module.exports.Reader = Reader
module.exports.Parser = Parser
