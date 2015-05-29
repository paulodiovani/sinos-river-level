expect = require('chai').expect
fs     = require('fs')
Stream = require('stream')

Reader = require('../lib/reader')

describe 'Reader', ->
  before ->
    @file  = './test/fixtures/dummy.html'
    @dummy = fs.readFileSync(@file)

  describe '#constructor', ->
    it 'accepts a file as source argument'

    it 'accepts an url as source argument'

  context 'public methods', ->
    beforeEach ->
      @reader = new Reader()

    describe '#getStream', ->
      it 'fails when no source is passed to constructor', ->
        expect(@reader.getStream.bind(@reader))
          .to.throw 'a valid source must be provided'

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
