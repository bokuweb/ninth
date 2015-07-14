Judge = cc.Class.extend
  ctor : (@_thresholds) ->
    EventEmitter = require "eventemitter-light"
    @_ee = Object.create(EventEmitter).constructor()

  addEventListener : (event, listener) ->
    @_ee.on event, listener

  judge : (diffTime) ->
    pgreat = @_thresholds.pgreat
    great = @_thresholds.great
    good = @_thresholds.good

    if -pgreat < diffTime < pgreat
      @_ee.emit 'pgreat'
    else if -great < diffTime < great
      @_ee.emit 'great'
    else if -good < diffTime < good
      @_ee.emit 'good'
    else
      @_ee.emit 'bad'

module.exports = Judge
