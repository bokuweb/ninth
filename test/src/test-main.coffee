TimerTest       = require './test-timer'
VideoTimerTest  = require './test-videoTimer'
JudgeTest       = require './test-judge'
TouchSpriteTest = require './test-touchSprite'
NoteTest        = require './test-note'
NotesLayerTest  = require './test-notesLayer'
NumaralFontTest = require './test-numeralFont'
StatsTest       = require './test-stats'

window.onload = ->
  cc.game.onStart = ->
    cc.view.enableRetina off
    cc.view.adjustViewPort on
    policy = new cc.ResolutionPolicy cc.ContainerStrategy.ORIGINAL_CONTAINER, cc.ContentStrategy.SHOW_ALL
    cc.view.setDesignResolutionSize 800, 600, policy
    cc.director.setContentScaleFactor 2

    timerTest       = new TimerTest()
    videoTimerTest  = new VideoTimerTest()
    judgeTest       = new JudgeTest() 
    touchSpriteTest = new TouchSpriteTest()
    noteTest        = new NoteTest()
    notesLayerTest  = new NotesLayerTest()
    numeralFontTest = new NumaralFontTest()
    statsTest       = new StatsTest()

    timerTest.start()
    #videoTimerTest.start()
    judgeTest.start()
    touchSpriteTest.start()
    noteTest.start()
    notesLayerTest.start()
    numeralFontTest.start()
    statsTest.start()
    
    if window.mochaPhantomJS
      mochaPhantomJS.run()
    else
      mocha.run()

  cc.game.run 'gameCanvas'
