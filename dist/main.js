(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var VideoPlayer;

VideoPlayer = require('./videoPlayer');

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
      var MyScene;
      MyScene = cc.Scene.extend({
        onEnter: function() {
          var size;
          this._super();
          size = cc.director.getWinSize();
          this._label = cc.LabelTTF.create("aHello World", "Arial", 40);
          this._label.setPosition(size.width / 2, size.height / 2);
          this.addChild(this._label);
          this._player = new VideoPlayer();
          return this.scheduleUpdate();
        },
        update: function() {
          if (this._player.isReady()) {
            return this._label.setString(this._player.getCurrentTime());
          }
        }
      });
      return cc.director.runScene(new MyScene());
    }, this);
  };
  return cc.game.run("gameCanvas");
};



},{"./videoPlayer":2}],2:[function(require,module,exports){
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
    this._isReady = true;
    return this._player.playVideo();
  }
});

module.exports = VideoPlayer;



},{}]},{},[1]);
