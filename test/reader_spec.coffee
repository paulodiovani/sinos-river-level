expect = require('chai').expect
fs     = require('fs')
Stream = require('stream')

Reader = require('../lib/reader')

describe 'Reader', ->
  before ->
    @file  = './test/fixtures/dummy.html'
    @dummy = fs.readFileSync(@file)

  beforeEach ->
    @reader = new Reader()

  describe '#getFileStream', ->
    beforeEach ->
      @stream = @reader.getFileStream @file

    it 'returns a stream', ->
      expect(@stream).to.be.instanceof Stream

    it 'contains dummy data', (done) ->
      fullData = ''
      @stream.on 'data', (data) ->
        fullData += data.toString()
      @stream.on 'end', =>
        expect(fullData).to.be.eql @dummy.toString()
        done()
