expect = require('chai').expect
fs     = require('fs')
url    = require('url')
http   = require('http')
https  = require('https')
Stream = require('stream')

Reader = require('../lib/reader')

describe 'Reader', ->
  before ->
    @file  = './test/fixtures/dummy.html'
    @dummy = fs.readFileSync @file

    pattern    = /<body[^>]*>((.|[\n\r])*)<\/body>/im
    matches    = pattern.exec @dummy.toString()
    @dummyBody = matches[1]

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

  context 'when reading from an http server', ->
    before ->
      @address = '127.0.0.1'
      @port    = 1338
      @url     = "http://#{@address}:#{@port}"

      @server = http.createServer (req, res) =>
        if req.url.indexOf('404') > -1
          res.writeHead 404
          res.end()
        else
          res.writeHead 200, 'Content-Type': 'text/html'
          res.end @dummy

      @server.listen @port, @address

    after ->
      @server.close()

    describe '#constructor', ->
      it 'accepts an url as source argument', (done) ->
        reader = new Reader @url
        expect(reader.sourceType).to.be.eql 'url'
        reader.getStream (err, stream) ->
          expect(err).to.be.null
          expect(stream).to.be.instanceof Stream
          done()

    describe '#getUrlStream', ->
      beforeEach (done) ->
        @reader.getUrlStream @url, (err, @stream) =>
          done()

      it 'returns a stream', ->
        expect(@stream).to.be.instanceof Stream

      it 'contains dummy data', (done) ->
        fullData = ''
        @stream.on 'data', (data) ->
          fullData += data.toString()
        @stream.on 'end', =>
          expect(fullData).to.have.string @dummyBody
          done()

      it 'fails to read non success response', (done) ->
        @reader.getUrlStream "#{@url}/404", (err, stream) ->
          expect(err).to.be.instanceof Error
          expect(err.message).to.be.eql 'http status 404: Not Found'
          done()

  context 'when reading from a secure http server', ->
    before ->
      @address = '127.0.0.1'
      @port    = 1338
      @url     = "https://#{@address}:#{@port}"

      @server = https.createServer
        key: fs.readFileSync './test/fixtures/server.key'
        cert: fs.readFileSync './test/fixtures/server.crt'
      , (req, res) =>
        res.writeHead 200, 'Content-Type': 'text/html'
        res.end @dummy

      @server.listen @port, @address

    after ->
      @server.close()

    describe '#getUrlStream', ->
      beforeEach (done) ->
        @reader.getUrlStream @url, (err, @stream) =>
          done()

      it 'returns a stream', ->
        expect(@stream).to.be.instanceof Stream

      it 'contains dummy data', (done) ->
        fullData = ''
        @stream.on 'data', (data) ->
          fullData += data.toString()
        @stream.on 'end', =>
          expect(fullData).to.have.string @dummyBody
          done()
