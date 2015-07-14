VideoTimer = cc.Layer.extend

  ctor : (@_player) ->
    @_super()
    Timer = require './timer'
    @_timer = new Timer()
    @_oldTime = 0
    @scheduleUpdate()

  update : ->
    if @_player.isReady()
      if @_player.getCurrentTime() > 0
        if @_timer.getCurrentTime() is 0
          @_timer.start()
        # syncronous timer
        if @_player.getCurrentTime() isnt @_oldTime
          @_timer.set @_player.getCurrentTime()
          @_oldTime = @_player.getCurrentTime()

  getCurrentTime : -> @_timer.getCurrentTime()



module.exports = VideoTimer
