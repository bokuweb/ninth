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



},{"./gameScene":3}],2:[function(require,module,exports){
module.exports = {
    on: function (ev, handler) {
        var events = this._events

        ;(events[ev] || (events[ev] = [])).push(handler)
    },
    removeListener: function (ev, handler) {
        var array = this._events[ev]

        array && array.splice(array.indexOf(handler), 1)
    },
    emit: function (ev) {
        var args = [].slice.call(arguments, 1),
            array = this._events[ev] || []

        for (var i = 0, len = array.length; i < len; i++) {
            array[i].apply(this, args)
        }
    },
    once: function (ev, handler) {
        this.on(ev, function () {
            handler.apply(this, arguments)
            this.removeListener(ev, handler)
        })
    },
    constructor: function constructor() {
        this._events = {}
        return this
    }
}

module.exports.constructor.prototype = module.exports

},{}],3:[function(require,module,exports){
var GameScene;

GameScene = cc.Scene.extend({
  ctor: function() {
    return this._super();
  },
  onEnter: function() {
    var Judge, NotesLayer, Stats, Timer, VideoPlayer, VideoTimer, judge, score, size;
    VideoPlayer = require('./videoPlayer');
    VideoTimer = require('./videotimer');
    NotesLayer = require('./notesLayer');
    Judge = require('./judge');
    Stats = require('./stats');
    Timer = require('./timer');
    this._super();
    size = cc.director.getWinSize();
    this._label = cc.LabelTTF.create("Hello Worlda", "Arial", 20);
    this._label.setPosition(size.width / 2, size.height / 2);
    this._player = new VideoPlayer();
    this._timer = new VideoTimer(this._player);
    this.addChild(this._timer);
    judge = new Judge({
      pgreat: 0.075,
      great: 0.15,
      good: 0.25
    });
    judge.addEventListener('pgreat', (function(_this) {
      return function() {
        console.log("pgreat");
        return _this._stats.reflect('pgreat');
      };
    })(this));
    judge.addEventListener('great', (function(_this) {
      return function() {
        console.log("great");
        return _this._stats.reflect('great');
      };
    })(this));
    judge.addEventListener('good', (function(_this) {
      return function() {
        return _this._stats.reflect('good');
      };
    })(this));
    judge.addEventListener('bad', (function(_this) {
      return function() {
        return _this._stats.reflect('bad');
      };
    })(this));
    score = [
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
    ];
    this._layer = new NotesLayer({
      noteImage: './img/box.png'
    }, this._timer, score, judge);
    this._stats = new Stats({
      score: {
        x: 100,
        y: 100,
        src: './img/number.png',
        width: 26.2,
        height: 16,
        scale: 0.8,
        margin: 0
      },
      comboNum: {
        x: 100,
        y: 200,
        src: './img/number.png',
        width: 26.2,
        height: 16,
        scale: 0.8,
        margin: 0
      }
    });
    this._stats.init(score.length, {
      pgreat: 150000,
      great: 100000,
      good: 20000,
      combo: 50000
    });
    this.addChild(this._label);
    this.addChild(this._layer);
    this.addChild(this._stats);
    this.scheduleUpdate();
    return this._layer.start();
  },
  update: function() {}
});

module.exports = GameScene;



},{"./judge":4,"./notesLayer":6,"./stats":8,"./timer":9,"./videoPlayer":11,"./videotimer":12}],4:[function(require,module,exports){
var Judge;

Judge = cc.Class.extend({
  ctor: function(_thresholds) {
    var EventEmitter;
    this._thresholds = _thresholds;
    EventEmitter = require("eventemitter-light");
    return this._ee = Object.create(EventEmitter).constructor();
  },
  addEventListener: function(event, listener) {
    return this._ee.on(event, listener);
  },
  judge: function(diffTime) {
    var good, great, pgreat;
    pgreat = this._thresholds.pgreat;
    great = this._thresholds.great;
    good = this._thresholds.good;
    if ((-pgreat < diffTime && diffTime < pgreat)) {
      return this._ee.emit('pgreat');
    } else if ((-great < diffTime && diffTime < great)) {
      return this._ee.emit('great');
    } else if ((-good < diffTime && diffTime < good)) {
      return this._ee.emit('good');
    } else {
      return this._ee.emit('bad');
    }
  }
});

module.exports = Judge;



},{"eventemitter-light":2}],5:[function(require,module,exports){
var Note;

Note = require('./touchSprite').extend({
  ctor: function(texture, _params, _timer, _judge) {
    var eventListener;
    this._params = _params;
    this._timer = _timer;
    this._judge = _judge;
    this._super(texture);
    this.setScale(0, 0);
    if ('keyboard' in cc.sys.capabilities) {
      eventListener = cc.EventListener.create({
        event: cc.EventListener.KEYBOARD,
        onKeyPressed: this._onKeyPressed.bind(this)
      });
      return cc.eventManager.addListener(eventListener, this);
    }
  },
  start: function() {
    return this.scheduleUpdate();
  },
  update: function() {
    var cb, currentTime, scale, seq;
    currentTime = this._timer.getCurrentTime();
    if (currentTime >= this._params.timing) {
      this.setScale(1, 1);
      this.setRotation(0);
    } else {
      if (this._params.timing - currentTime < this._params.inAnimationTime) {
        scale = 1 - (this._params.timing - currentTime);
        this.setScale(scale, scale);
        this.setRotation(scale * 720);
      }
    }
    if (currentTime >= this._params.timing + this._params.removeTiming) {
      this._judge.judge(this._params.timing - currentTime);
      this.unscheduleUpdate();
      cb = function() {
        return this.removeFromParent(true);
      };
      seq = cc.sequence(cc.fadeOut(0.2), cc.CallFunc.create(cb, this));
      return this.runAction(seq);
    }
  },
  _onTouchBegan: function(touch, event) {
    if (!this._super(touch, event)) {
      return;
    }
    return this._onHit();
  },
  _onKeyPressed: function(key, evnt) {
    var activeKeys;
    activeKeys = [90, 88, 67, 65, 83, 68, 81, 87, 69];
    console.log("@_params.key = " + this._params.key + ", key = " + key);
    if (activeKeys[this._params.key] === key) {
      return this._onHit();
    }
  },
  _onHit: function() {
    var cb, currentTime, seq, spawn;
    currentTime = this._timer.getCurrentTime();
    this._judge.judge(this._params.timing - currentTime);
    this.unscheduleUpdate();
    spawn = cc.spawn(cc.fadeOut(0.2, cc.scaleBy(0.2, 1.5, 1.5)));
    seq = cc.sequence(spawn, cc.CallFunc.create(cb, this));
    this.runAction(seq);
    return cb = function() {
      return this.removeFromParent(true);
    };
  }
});

module.exports = Note;



},{"./touchSprite":10}],6:[function(require,module,exports){
var NotesLayer;

NotesLayer = cc.Layer.extend({
  ctor: function(_skin, _timer, score, judge) {
    var Note, i, len, note, results, v;
    this._skin = _skin;
    this._timer = _timer;
    Note = require('./note');
    this._super();
    this._notes = [];
    this._index = 0;
    this._batchNode = new cc.SpriteBatchNode(this._skin.noteImage);
    this.addChild(this._batchNode, 100);
    results = [];
    for (i = 0, len = score.length; i < len; i++) {
      v = score[i];
      note = new Note(this._batchNode.getTexture(), {
        key: v.key,
        timing: v.timing,
        inAnimationTime: 0.2,
        removeTiming: 0.35
      }, this._timer, judge);
      note.x = (v.key % 3) * 105 + 58;
      note.y = ~~(v.key / 3) * 105 + 58;
      note.timing = v.timing;
      note.setScale(0, 0);
      results.push(this._notes.push(note));
    }
    return results;
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
    if (this._timer.getCurrentTime() >= note.timing - 0.2) {
      this._batchNode.addChild(note, 99);
      note.start();
      return this._index++;
    }
  }
});

module.exports = NotesLayer;



},{"./note":5}],7:[function(require,module,exports){
var NumeralLabel;

NumeralLabel = cc.Layer.extend({
  ctor: function(_skin) {
    this._skin = _skin;
    this._super();
    return this._sprites = [];
  },
  init: function(_digits, num) {
    var i, j, ref, scaledWidth;
    this._digits = _digits;
    if (num == null) {
      num = 0;
    }
    scaledWidth = this._skin.width * this._skin.scale;
    this._batchNode = new cc.SpriteBatchNode(this._skin.src);
    this.addChild(this._batchNode);
    this._frames = (function() {
      var j, results;
      results = [];
      for (i = j = 0; j < 10; i = ++j) {
        results.push(new cc.SpriteFrame(this._batchNode.texture, cc.rect(this._skin.width * i, 0, this._skin.width, this._skin.height)));
      }
      return results;
    }).call(this);
    for (i = j = 0, ref = this._digits; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      this._sprites[i] = new cc.Sprite();
      this._sprites[i].setSpriteFrame(this._frames[0]);
      this._sprites[i].x = i * (-scaledWidth - this._skin.margin) + (scaledWidth * this._digits / 2);
      this._sprites[i].scale = this._skin.scale;
      this._batchNode.addChild(this._sprites[i]);
    }
    return this.reflect(num);
  },
  reflect: function(num) {
    var i, j, ref, results;
    results = [];
    for (i = j = 0, ref = this._digits; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      this._sprites[i].setSpriteFrame(this._frames[~~(num % 10)]);
      results.push(num /= 10);
    }
    return results;
  }
});

module.exports = NumeralLabel;



},{}],8:[function(require,module,exports){
var StatsLayer;

StatsLayer = cc.Layer.extend({
  ctor: function(skin) {
    var NumeralLabel;
    this._super();
    NumeralLabel = require('./numeralFont');
    this._scoreLabel = new NumeralLabel(skin.score);
    this._comboLabel = new NumeralLabel(skin.comboNum);
    this._scoreLabel.x = skin.score.x;
    this._scoreLabel.y = skin.score.y;
    this._comboLabel.x = skin.comboNum.x;
    this._comboLabel.y = skin.comboNum.y;
    this.addChild(this._scoreLabel);
    return this.addChild(this._comboLabel);
  },
  init: function(_noteNum, maxScore) {
    this._noteNum = _noteNum;
    this._score = 0;
    this._dispScore = 0;
    this._maxCombo = 0;
    this._combo = 0;
    this._pgreatNum = 0;
    this._greatNum = 0;
    this._goodNum = 0;
    this._badNum = 0;
    this._poorNum = 0;
    this._comboPoint = 0;
    this._pgreatIncVal = maxScore.pgreat / this._noteNum;
    this._greatIncVal = maxScore.great / this._noteNum;
    this._goodIncVal = maxScore.good / this._noteNum;
    this._comboBonusFactor = maxScore.combo / (10 * (this._noteNum - 1) - 55);
    this._incValonUpdate = maxScore.good / this._noteNum / 10;
    this._scoreLabel.init(this._getDigits(maxScore.pgreat + maxScore.combo), 0);
    this._comboLabel.init(4, 0);
    return this.scheduleUpdate();
  },
  get: function() {
    return {
      score: ~~(this._score.toFixed()),
      combo: this._maxCombo,
      pgreat: this._pgreatNum,
      great: this._greatNum,
      good: this._goodNum,
      bad: this._badNum,
      poor: this._poorNum
    };
  },
  reflect: function(judge) {
    var ref;
    switch (judge) {
      case "pgreat":
        this._score += this._pgreatIncVal;
        this._combo++;
        this._pgreatNum++;
        break;
      case "great":
        this._score += this._greatIncVal;
        this._combo++;
        this._greatNum++;
        break;
      case "good":
        this._score += this._goodIncVal;
        this._combo++;
        this._goodNum++;
        break;
      case "bad":
        this._score += this._comboBonusFactor * this._comboPoint;
        this._combo = 0;
        this._comboPoint = 0;
        this._badNum++;
        break;
    }
    if (this._combo === this._noteNum) {
      this._score += this._comboBonusFactor * this._comboPoint;
      this._comboPoint = 0;
    }
    if ((0 < (ref = this._combo) && ref <= 10)) {
      this._comboPoint += this._combo - 1;
    } else if (this._combo > 10) {
      this._comboPoint += 10;
    }
    if (this._combo > this._maxCombo) {
      this._maxCombo = this._combo;
    }
    return this._comboLabel.reflect(this._maxCombo);
  },
  update: function() {
    if (this._dispScore < ~~(this._score.toFixed())) {
      this._dispScore += this._incValonUpdate;
      this._dispScore = this._dispScore > ~~(this._score.toFixed()) ? ~~(this._score.toFixed()) : this._dispScore;
      return this._scoreLabel.reflect(this._dispScore);
    }
  },
  _getDigits: function(num) {
    return Math.log(num) / Math.log(10) + 1 | 0;
  }
});

module.exports = StatsLayer;



},{"./numeralFont":7}],9:[function(require,module,exports){
var Timer;

Timer = cc.Class.extend({
  ctor: function() {
    this._startTime = 0;
    return this._pauseTime = 0;
  },
  start: function() {
    return this._startTime = new Date();
  },
  set: function(time_sec) {
    this._startTime = new Date();
    return this._pauseTime = time_sec * 1000;
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



},{}],10:[function(require,module,exports){
var TouchSprite;

TouchSprite = cc.Sprite.extend({
  ctor: function(texture) {
    var eventListener;
    this._super(texture);
    this._hasTouched = false;
    eventListener = cc.EventListener.create({
      event: cc.EventListener.TOUCH_ONE_BY_ONE,
      swallowTouches: true,
      onTouchBegan: this._onTouchBegan.bind(this)
    });
    return cc.eventManager.addListener(eventListener, this);
  },
  _onTouchBegan: function(touch, event) {
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



},{}],11:[function(require,module,exports){
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
    return this._isReady = true;
  }
});

module.exports = VideoPlayer;



},{}],12:[function(require,module,exports){
var VideoTimer;

VideoTimer = cc.Layer.extend({
  ctor: function(_player) {
    var Timer;
    this._player = _player;
    this._super();
    Timer = require('./timer');
    this._timer = new Timer();
    this._oldTime = 0;
    return this.scheduleUpdate();
  },
  update: function() {
    if (this._player.isReady()) {
      if (this._player.getCurrentTime() > 0) {
        if (this._timer.getCurrentTime() === 0) {
          console.log("timerstart");
          this._timer.start();
        }
        if (this._player.getCurrentTime() !== this._oldTime) {
          this._timer.set(this._player.getCurrentTime());
          return this._oldTime = this._player.getCurrentTime();
        }
      }
    }
  },
  getCurrentTime: function() {
    console.log(this._timer);
    return this._timer.getCurrentTime();
  }
});

module.exports = VideoTimer;



},{"./timer":9}]},{},[1]);
