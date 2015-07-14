GameScene = cc.Scene.extend
  ctor : ->
    @_super()

  onEnter : ->
    VideoPlayer = require './videoPlayer'
    VideoTimer  = require './videotimer'
    NotesLayer  = require './notesLayer'

    @_super()
    size = cc.director.getWinSize()
    @_label = cc.LabelTTF.create "Hello Worlda", "Arial", 20
    @_label.setPosition size.width / 2, size.height / 2
    @_player = new VideoPlayer()
    @_timer = new VideoTimer @_player
    @addChild @_timer
    @_layer = new NotesLayer {noteImage : './img/box.png'}, @_timer, [
      {timing : 1, key : 0}
      {timing : 2, key : 1}
      {timing : 3, key : 2}
      {timing : 4, key : 3}
      {timing : 5, key : 4}
      {timing : 6, key : 5}
      {timing : 7, key : 6}
      {timing : 8, key : 7}
      {timing : 9, key : 8}
    ]
    @addChild @_label
    @addChild @_layer
    @scheduleUpdate()

  update : -> @_startNotesLayerIfReady()

  _startNotesLayerIfReady : ->
    if @_player.isReady() # and @_player.getCurrentTime() is 0
      @_layer.start()

module.exports = GameScene

