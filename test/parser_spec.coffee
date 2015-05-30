expect = require('chai').expect
fs     = require('fs')

Parser = require('../lib/parser')

describe 'Parser', ->
  beforeEach ->
    @dummy  = fs.createReadStream('./test/fixtures/dummy.html')
    @parser = new Parser(@dummy)

  describe '#getYears', ->
    it 'lists available years', (done) ->
      @parser.getYears (err, years) ->
        expect(err).to.be.null
        expect(years).to.be.eql years: ['2001', '2002', '2003', '2004']
        done()
