NotesLayerTest = cc.Class.extend
  start : ->
    describe 'NotesLayerclass test', ->
      @timeout 0
      NotesLayer = require '../../src/notesLayer'
      Timer = require '../../src/timer'
      Judge = require '../../src/judge'
      expect = chai.expect

      it 'notesLayer create test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            if window.mochaPhantomJS
              console.log "skip touch sprite test"
              done()

            size = cc.director.getWinSize()
            @_timer = new Timer()

            @_judge = new Judge
              pgreat : 0.05
              great  : 0.1
              good   : 0.2

            @_layer = new NotesLayer {noteImage : '../test/img/box.png'}, @_timer, [
                {timing : 1, key : 0}
                {timing : 2, key : 1}
                {timing : 3, key : 2}
                {timing : 4, key : 3}
                {timing : 5, key : 4}
                {timing : 6, key : 5}
                {timing : 7, key : 6}
                {timing : 8, key : 7}
                {timing : 9, key : 8}
              ], @_judge

            @addChild @_layer
            @_layer.start()
            @_timer.start()
            @scheduleUpdate()

          update : ->
            if @_timer.getCurrentTime() > 10
              @unscheduleUpdate()
              done()

        cc.director.runScene new TestScene()

      before ->

      after ->

module.exports = NotesLayerTest


