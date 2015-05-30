expect = require('chai').expect

SinosLevel = require('../lib/sinos_level')

describe 'index', ->
  it 'exports SinosLevel class', ->
    expect(require '../index').to.be.eql SinosLevel
