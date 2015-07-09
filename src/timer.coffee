Timer = cc.Class.extend
  ctor : ->
    @_startTime = 0
    @_pauseTime = 0

  start : -> @_startTime  = new Date()

  set : (time_msec)->
    @_startTime  = new Date()
    @_pauseTime = time_msec

  getCurrentTime : ->
    if @_startTime
      ((new Date() - @_startTime) + @_pauseTime) / 1000
    else 0

  pause : -> @_pauseTime = ((new Date() - @_startTime) + @_pauseTime)

  stop : ->
    @_startTime = 0
    @_pauseTime = 0

module.exports = Timer
