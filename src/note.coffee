TouchSprite = require './touchSprite'

Note = TouchSprite.extend

  ctor : (texture, @_params, @_timer, @_judge) ->
    @_super texture
    @setScale 0, 0

  start : -> @scheduleUpdate()

  update : ->
    currentTime = @_timer.getCurrentTime()

    # in animation
    if currentTime >= @_params.timing
      @setScale 1, 1
      @setRotation 0
    else
      if @_params.timing - currentTime < @_params.inAnimationTime
        scale = 1 - (@_params.timing - currentTime)
        @setScale scale, scale
        @setRotation scale * 720

    if currentTime >= @_params.timing + @_params.removeTiming
      #@_judge.judge (@_params.timing - currentTime)

      # remove animation
      @unscheduleUpdate()
      cb =-> @removeFromParent on
      seq = cc.sequence(
        cc.fadeOut 0.2
        cc.CallFunc.create cb, this
      )
      @runAction seq

  onTouchBegan : (touch, event) ->
    return unless @_super touch, event
    currentTime = @_timer.getCurrentTime()
    @_judge.judge (@_params.timing - currentTime)
    @unscheduleUpdate()
    spawn = cc.spawn cc.fadeOut 0.2, cc.scaleBy 0.2, 1.5, 1.5
    seq = cc.sequence spawn, cc.CallFunc.create cb, this
    @runAction seq
    cb =-> @removeFromParent on

module.exports = Note
