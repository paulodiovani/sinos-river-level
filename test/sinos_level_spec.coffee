expect = require('chai').expect

SinosLevel = require('../lib/sinos_level')
Reader     = require('../lib/reader')
Parser     = require('../lib/parser')

describe 'SinosLevel', ->
  describe '.self', ->
    it 'contains a Reader', ->
      expect(SinosLevel.Reader).to.be.eql Reader

    it 'contains a Parser', ->
      expect(SinosLevel.Parser).to.be.eql Parser
