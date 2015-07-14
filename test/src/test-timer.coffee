TimerTest = cc.Class.extend
  start : ->
    describe 'timer class test', ->
      @timeout 10000
      Timer  = require '../../src/timer'
      expect = chai.expect

      it 'should timer.get() return 0 before start', ->
        time = @_timer.getCurrentTime()
        expect time
          .to.be.equal 0

      it 'set timer 1000msec, should get() return about 1000msec', (done)->
        @_timer.start()
        setTimeout =>
          time = @_timer.getCurrentTime()
          expect time
            .to.be.within 0.9, 1.1
          @_timer.stop()
          done()
        , 1000

      before ->
        @_timer = new Timer()

module.exports = TimerTest


