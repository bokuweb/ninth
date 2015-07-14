NotesLayer = cc.Layer.extend
  ctor : (@_skin, @_timer, @_score, @_judge) ->
    Note = require './note'
    @_super()
    @_notes = []
    @_index = 0
    @_batchNode = new cc.SpriteBatchNode @_skin.noteImage
    @addChild @_batchNode, 100

    for v in @_score
      note = new Note @_batchNode.getTexture(), {
          timing          : v.timing
          inAnimationTime : 0.15
          removeTiming    : 0.2
        }, @_timer, @_judge
      note.x = (v.key % 3) * 105 + 58
      note.y = ~~(v.key / 3) * 105 + 58
      note.timing = v.timing
      note.setScale 0, 0
      @_notes.push note
    return

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
