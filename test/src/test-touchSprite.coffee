TouchSpriteTest = cc.Class.extend
  start : ->
    describe 'touchSprite class test', ->
      @timeout 20000
      TouchSprite = require '../../src/touchSprite'
      expect = chai.expect

      it 'touchSprite create and touch test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            if window.callPhantom?
              console.log "skip touch sprite test"
              done()

            size = cc.director.getWinSize()
            @_s = new TouchSprite '../test/img/box.png'
            @_s.x = size.width / 2
            @_s.y = size.height / 2
            @addChild @_s

            expect(@children.length).to.be.equal 1

            @scheduleUpdate()

          update : ->
            if @_s.hasTouched()
              console.log "touched"
              @unscheduleUpdate()
              done()

        cc.director.runScene new TestScene()

      before ->

      after ->

module.exports = TouchSpriteTest


