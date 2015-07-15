StatsTest = cc.Class.extend
  start : ->
    describe 'stats class test', ->
      @timeout 10000
      Stats  = require '../../src/stats'
      capture = require './test-utils'
      expect = chai.expect
      testNoteNum = 30
      skin =
        score :
          x      : 400
          y      : 200
          src    :  '../test/img/number.png'
          width  : 26.2
          height : 16
          scale  : 0.8
          margin : 0
        comboNum :
          x      : 100
          y      : 200
          src    :  '../test/img/number.png'
          width  : 26.2
          height : 16
          scale  : 0.8
          margin : 0

      it 'initialize stats and capture stats', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new Stats skin
            stats.init  testNoteNum,
              pgreat : 150000
              great  : 100000
              good   : 20000
              combo  : 50000
            @addChild stats
            expect(stats.get().score).to.be.equal 0
            expect(stats.get().combo).to.be.equal 0
            expect(stats.get().pgreat).to.be.equal 0
            expect(stats.get().great).to.be.equal 0
            expect(stats.get().good).to.be.equal 0
            expect(stats.get().bad).to.be.equal 0
            expect(stats.get().poor).to.be.equal 0
            setTimeout =>
              done()
            , 1000
        cc.director.runScene new TestScene()


      it 'score is 200000 when all pgreat', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new Stats skin
            stats.init  testNoteNum,
              pgreat : 150000
              great  : 100000
              good   : 20000
              combo  : 50000
            @addChild stats
            stats.reflect 'pgreat' for i in [0...testNoteNum]
            setTimeout =>
              console.log stats.get().score
              expect(stats.get().score).to.be.equal 200000
              expect(stats.get().combo).to.be.equal testNoteNum
              expect(stats.get().pgreat).to.be.equal testNoteNum
              expect(stats.get().great).to.be.equal 0
              expect(stats.get().good).to.be.equal 0
              expect(stats.get().bad).to.be.equal 0
              expect(stats.get().poor).to.be.equal 0              
              done()
            , 5000
        cc.director.runScene new TestScene()

module.exports = StatsTest


