NoteTest = cc.Class.extend
  start : ->
    describe 'Note class test', ->
      @timeout 20000
      Note = require '../../src/note'
      Timer = require '../../src/timer'
      Judge = require '../../src/judge'
      expect = chai.expect

      it 'note create and touch test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            if window.mochaPhantomJS
              console.log "skip touch sprite test"
              done()
            size = cc.director.getWinSize()
            @_judge = new Judge
              pgreat : 0.05
              great  : 0.1
              good   : 0.2

            @_player = new Timer()
            @_n = new Note '../test/img/box.png', {
                timing          : 1
                inAnimationTime : 0.15
                removeTiming    : 0.2
              }, @_player, @_judge

            @_n.x = size.width / 2
            @_n.y = size.height / 2
            @addChild @_n
            expect(@children.length).to.be.equal 1
            @_player.start()
            @_n.start()
            @scheduleUpdate()

          update : ->
            if @_n.hasTouched() or @children.length is 0
              @unscheduleUpdate()
              @scheduleOnce ->
                done()
              , 1

        cc.director.runScene new TestScene()

      before ->

      after ->

module.exports = NoteTest


