(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
window.onload = function() {
  cc.game.onStart = function() {
    var height;
    cc.view.enableRetina(false);
    cc.view.adjustViewPort(true);
    if (cc.sys.isMobile) {
      height = cc.view.getFrameSize().height / cc.view.getFrameSize().width * 320;
      cc.view.setDesignResolutionSize(320, height, cc.ResolutionPolicy.SHOW_ALL);
    }
    cc.view.resizeWithBrowserSize(true);
    cc.director.setContentScaleFactor(2);
    return cc.LoaderScene.preload([], function() {
      var GameScene;
      GameScene = require('./gameScene');
      return cc.director.runScene(new GameScene());
    }, this);
  };
  return cc.game.run("gameCanvas");
};



},{"./gameScene":2}],2:[function(require,module,exports){
var GameScene;

GameScene = cc.Scene.extend({
  ctor: function() {
    return this._super();
  },
  onEnter: function() {
    var NotesLayer, Timer, VideoPlayer, size;
    VideoPlayer = require('./videoPlayer');
    Timer = require('./timer');
    NotesLayer = require('./notesLayer');
    this._super();
    size = cc.director.getWinSize();
    this._label = cc.LabelTTF.create("Hello World", "Arial", 20);
    this._label.setPosition(size.width / 2, size.height / 2);
    this.addChild(this._label);
    this._player = new VideoPlayer();
    this._timer = new Timer();
    this._layer = new NotesLayer({
      noteImage: './img/box.png'
    }, this._timer, [
      {
        timing: 1,
        key: 0
      }, {
        timing: 2,
        key: 1
      }, {
        timing: 3,
        key: 2
      }, {
        timing: 4,
        key: 3
      }, {
        timing: 5,
        key: 4
      }, {
        timing: 6,
        key: 5
      }, {
        timing: 7,
        key: 6
      }, {
        timing: 8,
        key: 7
      }, {
        timing: 9,
        key: 8
      }
    ]);
    console.log("hoge");
    this.addChild(this._layer);
    return this.scheduleUpdate();
  },
  update: function() {
    if (this._player.isReady()) {
      this._layer.start();
      if (this._player.getCurrentTime() > 0) {
        if (this._timer.getCurrentTime() === 0) {
          this._timer.start();
        }
      }
      return this._label.setString(this._timer.getCurrentTime());
    }
  }
});

module.exports = GameScene;



},{"./notesLayer":4,"./timer":5,"./videoPlayer":7}],3:[function(require,module,exports){
var Note, TouchSprite;

TouchSprite = require('./touchSprite');

Note = TouchSprite.extend({
  ctor: function(texture, _params, _player, _judge) {
    this._params = _params;
    this._player = _player;
    this._judge = _judge;
    this._super(texture);
    return this.setScale(0, 0);
  },
  start: function() {
    return this.scheduleUpdate();
  },
  update: function() {
    var currentTime, scale;
    currentTime = this._player.getCurrentTime();
    if (currentTime >= this._params.timing) {
      this.setScale(1, 1);
      return this.setRotation(0);
    } else {
      if (this._params.timing - currentTime < this._params.inAnimationTime) {
        scale = 1 - (this._params.timing - currentTime);
        this.setScale(scale, scale);
        return this.setRotation(scale * 720);
      }
    }
  },
  onTouchBegan: function(touch, event) {
    var cb, seq, spawn;
    if (!this._super(touch, event)) {
      return;
    }
    this.unscheduleUpdate();
    spawn = cc.spawn(cc.fadeOut(0.2, cc.scaleBy(0.2, 1.5, 1.5)));
    seq = cc.sequence(spawn, cc.CallFunc.create(cb, this));
    this.runAction(seq);
    return cb = function() {
      return this.removeFromParent(true);
    };
  }

  /*
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
   */
});

module.exports = Note;



},{"./touchSprite":6}],4:[function(require,module,exports){
var NotesLayer;

NotesLayer = cc.Layer.extend({
  ctor: function(_skin, _player, _score) {
    var Note, i, len, note, ref, v;
    this._skin = _skin;
    this._player = _player;
    this._score = _score;
    Note = require('./note');
    this._super();
    this._notes = [];
    this._index = 0;
    this._batchNode = new cc.SpriteBatchNode(this._skin.noteImage);
    this.addChild(this._batchNode, 100);
    ref = this._score;
    for (i = 0, len = ref.length; i < len; i++) {
      v = ref[i];
      note = new Note(this._batchNode.getTexture(), {
        timing: v.timing,
        inAnimationTime: 0.15
      }, this._player);
      note.x = ((v.key % 3) + 1) * 105;
      note.y = (~~(v.key / 3) + 1) * 105;
      note.timing = v.timing;
      note.setScale(0, 0);
      this._notes.push(note);
    }
  },
  start: function() {
    return this.scheduleUpdate();
  },
  update: function() {
    var note;
    note = this._notes[this._index];
    if (note == null) {
      return;
    }
    if (this._player.getCurrentTime() >= note.timing - 0.2) {
      this._batchNode.addChild(note, 99);
      note.start();
      return this._index++;
    }
  }
});

module.exports = NotesLayer;



},{"./note":3}],5:[function(require,module,exports){
var Timer;

Timer = cc.Class.extend({
  ctor: function() {
    this._startTime = 0;
    return this._pauseTime = 0;
  },
  start: function() {
    return this._startTime = new Date();
  },
  set: function(time_msec) {
    this._startTime = new Date();
    return this._pauseTime = time_msec;
  },
  getCurrentTime: function() {
    if (this._startTime) {
      return ((new Date() - this._startTime) + this._pauseTime) / 1000;
    } else {
      return 0;
    }
  },
  pause: function() {
    return this._pauseTime = (new Date() - this._startTime) + this._pauseTime;
  },
  stop: function() {
    this._startTime = 0;
    return this._pauseTime = 0;
  }
});

module.exports = Timer;



},{}],6:[function(require,module,exports){
var TouchSprite;

TouchSprite = cc.Sprite.extend({
  ctor: function(texture) {
    var eventListener;
    this._super(texture);
    this._hasTouched = false;
    eventListener = cc.EventListener.create({
      event: cc.EventListener.TOUCH_ONE_BY_ONE,
      swallowTouches: true,
      onTouchBegan: this.onTouchBegan.bind(this)
    });
    return cc.eventManager.addListener(eventListener, this);
  },
  onTouchBegan: function(touch, event) {
    var locationInNode, rect, s, target;
    target = event.getCurrentTarget();
    locationInNode = target.convertToNodeSpace(touch.getLocation());
    s = target.getContentSize();
    rect = cc.rect(0, 0, s.width, s.height);
    if (cc.rectContainsPoint(rect, locationInNode)) {
      return this._hasTouched = true;
    }
  },
  hasTouched: function() {
    return this._hasTouched;
  }
});

module.exports = TouchSprite;



},{}],7:[function(require,module,exports){
var VideoPlayer;

VideoPlayer = cc.Class.extend({
  ctor: function(params) {
    var firstScriptTag, tag;
    this._player = null;
    this._isReady = false;
    this._state = null;
    tag = document.createElement('script');
    tag.src = 'https://www.youtube.com/iframe_api';
    firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    return window.onYouTubeIframeAPIReady = this._onYouTubeIframeAPIReady.bind(this);
  },
  play: function() {
    return this._player.playVideo();
  },
  getCurrentTime: function() {
    return this._player.getCurrentTime();
  },
  setVolume: function(volume) {
    return this._player.setVolume(volume);
  },
  getVolume: function() {
    return this._player.getVolume();
  },
  isReady: function() {
    console.log(this._isReady);
    return this._isReady;
  },
  _onYouTubeIframeAPIReady: function() {
    return this._player = new YT.Player('player', {
      videoId: 'HNYkOJ-T63k',
      width: 320,
      height: 240,
      events: {
        'onReady': this._onPlayerReady.bind(this)
      }
    });
  },
  _onPlayerReady: function() {
    console.log("ready");
    this._isReady = true;
    return this._player.playVideo();
  }
});

module.exports = VideoPlayer;



},{}]},{},[1]);
