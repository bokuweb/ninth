GameScene = cc.Scene.extend
  ctor : ->
    @_super()

  onEnter : ->
    VideoPlayer = require './videoPlayer'
    VideoTimer  = require './videotimer'
    NotesLayer  = require './notesLayer'
    Judge       = require './judge'
    Stats       = require './stats'
    # debug
    Timer       = require './timer'
    @_super()
    size = cc.director.getWinSize()
    @_label = cc.LabelTTF.create "Hello Worlda", "Arial", 20
    @_label.setPosition size.width / 2, size.height / 2

    @_player = new VideoPlayer()
    @_timer = new VideoTimer @_player
    @addChild @_timer
    # debug
    #@_timer = new Timer()
    #@_timer.start()

    judge = new Judge
      pgreat : 0.075
      great  : 0.15
      good   : 0.25

    judge.addEventListener 'pgreat', =>
      console.log "pgreat"
      @_stats.reflect 'pgreat'
    judge.addEventListener 'great', =>
      console.log "great"
      @_stats.reflect 'great'
    judge.addEventListener 'good', =>
      @_stats.reflect 'good'
    judge.addEventListener 'bad', =>
      @_stats.reflect 'bad'

    score = [
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

    @_layer = new NotesLayer {noteImage : './img/box.png'}, @_timer, score, judge

    @_stats = new Stats
      score :
        x      : 100
        y      : 100
        src    :  './img/number.png'
        width  : 26.2
        height : 16
        scale  : 0.8
        margin : 0
      comboNum :
        x      : 100
        y      : 200
        src    :  './img/number.png'
        width  : 26.2
        height : 16
        scale  : 0.8
        margin : 0

    @_stats.init score.length,
      pgreat : 150000
      great  : 100000
      good   : 20000
      combo  : 50000

    @addChild @_label
    @addChild @_layer
    @addChild @_stats    
    @scheduleUpdate()
    @_layer.start()
    
  update : ->


module.exports = GameScene

