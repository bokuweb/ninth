VideoPlayer = require './videoPlayer'

window.onload = ->

  cc.game.onStart = ->
    cc.view.enableRetina off
    cc.view.adjustViewPort on

    if cc.sys.isMobile
      height =  cc.view.getFrameSize().height / cc.view.getFrameSize().width * 320
      cc.view.setDesignResolutionSize 320, height, cc.ResolutionPolicy.SHOW_ALL 
    cc.view.resizeWithBrowserSize on
    cc.director.setContentScaleFactor 2

    cc.LoaderScene.preload [], ->
      MyScene = cc.Scene.extend
        onEnter : ->
          @_super()
          size = cc.director.getWinSize()
          @_label = cc.LabelTTF.create("aHello World", "Arial", 40)
          @_label.setPosition(size.width / 2, size.height / 2)
          @addChild @_label

          @_player = new VideoPlayer()
          @scheduleUpdate()

        update : ->
          if @_player.isReady()
            @_label.setString @_player.getCurrentTime()

      cc.director.runScene new MyScene()

    , this

  cc.game.run "gameCanvas"
