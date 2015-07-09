TouchSprite = require './touchSprite'

Note = TouchSprite.extend

  ctor : (texture, @_params, @_player, @_judge)->
    @_super texture
    @setScale 0, 0

  start : -> @scheduleUpdate()

  update : ->
    currentTime = @_player.getCurrentTime()

    if currentTime >= @_params.timing
      @setScale 1, 1
      @setRotation 0
    else
      if @_params.timing - currentTime < @_params.inAnimationTime
        scale = 1 - (@_params.timing - currentTime)
        @setScale scale, scale
        @setRotation scale * 720

    #if currentTime >= @_params.timing + @_params.threshold.good
    #  @_trigger 'judge', 'bad'

    #  @unscheduleUpdate()
    #  cb =-> @removeFromParent on
    #  seq = cc.sequence(
    #    cc.fadeOut 0.2
    #    cc.CallFunc.create cb, this
    #  )
    #  @runAction seq

  onTouchBegan : (touch, event)->
    return unless @_super touch, event
    #@_judge()
    @unscheduleUpdate()
    spawn = cc.spawn cc.fadeOut 0.2, cc.scaleBy 0.2, 1.5, 1.5
    seq = cc.sequence spawn, cc.CallFunc.create cb, this
    @runAction seq
    cb =-> @removeFromParent on

  ###
  _judge : ->
    currentTime = @_timer.get()
    diffTime = currentTime - @_params.timing
    great = @_params.threshold.great
    good = @_params.threshold.good
    if -great < diffTime < great
      @_trigger 'judge', 'great'
    else if -good < diffTime < good
      @_trigger 'judge', 'good'
    else
      @_trigger 'judge', 'bad'
  ###

module.exports = Note
