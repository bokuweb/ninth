NotesLayer = cc.Layer.extend
  ctor : (@_skin, @_timer, score, judge) ->
    Note = require './note'
    @_super()
    @_notes = []
    @_index = 0
    @_batchNode = new cc.SpriteBatchNode @_skin.noteImage
    @addChild @_batchNode, 100

    for v in score
      note = new Note @_batchNode.getTexture(), {
          key             : v.key
          timing          : v.timing
          inAnimationTime : 0.2
          removeTiming    : 0.35
        }, @_timer, judge
      note.x = (v.key % 3) * 105 + 58
      note.y = ~~(v.key / 3) * 105 + 58
      note.timing = v.timing
      note.setScale 0, 0
      @_notes.push note

  start : ->
    @scheduleUpdate()

  update : ->
    note = @_notes[@_index]
    return unless note?
    if @_timer.getCurrentTime() >= note.timing - 0.2
      @_batchNode.addChild note, 99
      note.start()
      @_index++

module.exports = NotesLayer
