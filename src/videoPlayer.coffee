VideoPlayer = cc.Class.extend
  ctor : (params) ->
    @_player  = null
    @_isReady = false
    @_state   = null
    tag = document.createElement 'script'
    tag.src = 'https://www.youtube.com/iframe_api'
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  play : -> @_player.playVideo()

  getCurrentTime : -> @_player.getCurrentTime()

  setVolume : (volume) -> @_player.setVolume volume

  getVolume : -> @_player.getVolume()

  isReady : -> @_isReady

  onPlayerReady = ->
    console.log "ready"
    @_isReady = true
    @_player.playVideo()

  window.onYouTubeIframeAPIReady = ->
    console.log "onYoutubeIframe readty"
    @_player = new YT.Player 'player',
      videoId : 'HNYkOJ-T63k'
      width : 320
      height : 240
      events  :
        'onReady': onPlayerReady

module.exports = VideoPlayer
