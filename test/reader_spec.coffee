expect = require('chai').expect
fs     = require('fs')
Stream = require('stream')

Reader = require('../lib/reader')

describe 'Reader', ->
  before ->
    @file  = './test/fixtures/dummy.html'
    @dummy = fs.readFileSync @file

  beforeEach ->
    @reader = new Reader()

  describe '#getStream', ->
    it 'fails when no source is passed to constructor', (done) ->
      @reader.getStream (err, stream) ->
        expect(err).to.be.instanceof Error
        expect(err.message).to.be.eql 'a valid source must be provided'
        done()

  context 'when reading from a file', ->
    describe '#constructor', ->
      it 'accepts a file as source argument', (done)->
        reader = new Reader @file
        expect(reader.sourceType).to.be.eql 'file'
        reader.getStream (err, stream) ->
          expect(err).to.be.null
          expect(stream).to.be.instanceof Stream
          done()

    describe '#getFileStream', ->
      beforeEach (done) ->
        @reader.getFileStream @file, (err, @stream) =>
          done()

      it 'returns a stream', ->
        expect(@stream).to.be.instanceof Stream

      it 'contains dummy data', (done) ->
        fullData = ''
        @stream.on 'data', (data) ->
          fullData += data.toString()
        @stream.on 'end', =>
          expect(fullData).to.be.eql @dummy.toString()
          done()
