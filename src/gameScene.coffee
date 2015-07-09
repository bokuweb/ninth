GameScene = cc.Scene.extend
  ctor : ->
    @_super()

  onEnter : ->
    VideoPlayer = require './videoPlayer'
    Timer       = require './timer'
    NotesLayer  = require './notesLayer'

    @_super()
    size = cc.director.getWinSize()
    @_label = cc.LabelTTF.create "Hello World", "Arial", 20
    @_label.setPosition size.width / 2, size.height / 2
    @addChild @_label
    @_player = new VideoPlayer()
    @_timer = new Timer()
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
    console.log "hoge"
    @addChild @_layer

    #@_player.start()
    @scheduleUpdate()

  update : ->
    if @_player.isReady()
      @_layer.start()

      if @_player.getCurrentTime() > 0
        if @_timer.getCurrentTime() is 0
          @_timer.start()

      @_label.setString @_timer.getCurrentTime()

module.exports = GameScene

