VideoTimerTest = cc.Class.extend
  start : ->
    describe 'videoTimer class test', ->
      @timeout 10000
      Timer  = require '../../src/timer'
      VideoTimer = require '../../src/videoTimer'
      expect = chai.expect

      it 'video timer start', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            videoTimer = new VideoTimer Timer
            @addChild videoTimer
            @scheduleOnce ->
              done()
            , 5

        cc.director.runScene new TestScene()

module.exports = VideoTimerTest


