NumeralFontTest = cc.Class.extend

  start : ->
    describe 'numeral font class test', ->
      @timeout 10000
      NumeralFont = require '../../src/numeralFont'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'numeral layer create and reflect test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()

            numeralFont = new NumeralFont
              src    :  '../test/img/number.png'
              width  : 26.2
              height : 16
              scale  : 0.8
              margin : 0
            numeralFont.init 10, 0
            size = cc.director.getWinSize()
            numeralFont.x = size.width / 2
            numeralFont.y = size.height / 2
            @addChild numeralFont

            expect @children.length
              .to.be.equal 1

            setTimeout =>
              numeralFont.reflect 123456789
              capture "test/capture/numeralFont/num" + capNum++
            , 1000

            setTimeout =>
              numeralFont.reflect 9876543210
              capture "test/capture/numeralFont/num" + capNum++
            , 2000

            setTimeout =>
              capture "test/capture/numeralFont/num" + capNum++
              done()
            , 3000

        cc.director.runScene new TestScene()

      before ->

      after ->

module.exports = NumeralFontTest

