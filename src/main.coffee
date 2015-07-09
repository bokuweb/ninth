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
      GameScene = require './gameScene'
      cc.director.runScene new GameScene()
    , this

  cc.game.run "gameCanvas"
