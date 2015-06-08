SinosLevel = require('../lib/sinos_level')

argv = require('minimist') process.argv.slice(2),
  boolean: [
    'years'
  ]
  alias:
    help: ['h']
    source: ['s', 'url', 'file']
    years: ['y']

source = argv.source or argv._[0]
sinos = new SinosLevel source

switch
  # get years
  when argv.years
    sinos.init (err) ->
      return console.error err if err?

      sinos.getYears (err, years) ->
        return console.error err if err?
        console.log years

  # print help
  else
    console.log """
    usage: sinos-level [OPTIONS] [INPUT_SOURCE]

    INPUT_SOURCE:
      file or url to read from

    OPTIONS:
      -h, --help                  Print this help
      -s, --source, --url, --file Set INPUT_SOURCE
      -y, --years                 Print available years at source
    """
