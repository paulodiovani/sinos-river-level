expect = require('chai').expect
fs     = require('fs')

SinosLevel = require('../lib/sinos_level')
Reader     = require('../lib/reader')
Parser     = require('../lib/parser')

describe 'SinosLevel', ->
  before ->
    @file  = './test/fixtures/dummy.html'

  describe '.self', ->
    it 'contains a Reader', ->
      expect(SinosLevel.Reader).to.be.eql Reader

    it 'contains a Parser', ->
      expect(SinosLevel.Parser).to.be.eql Parser

  describe '#constructor', ->
    it 'has a default source', ->
      sinos = new SinosLevel()
      expect(sinos.source).to.be.not.null

    it 'accepts a different source', ->
      sinos = new SinosLevel @file
      expect(sinos.source).to.be.eql @file

