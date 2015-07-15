StatsLayer = cc.Layer.extend
  ctor: (skin) ->
    @_super()
    NumeralLabel = require './numeralFont'
    @_scoreLabel = new NumeralLabel skin.score
    @_comboLabel =  new NumeralLabel skin.comboNum
    @_scoreLabel.x = skin.score.x
    @_scoreLabel.y = skin.score.y
    @_comboLabel.x = skin.comboNum.x
    @_comboLabel.y = skin.comboNum.y
    @addChild @_scoreLabel
    @addChild @_comboLabel

  init : (@_noteNum, maxScore) ->
    @_score = 0
    @_dispScore = 0
    @_maxCombo = 0
    @_combo = 0
    @_pgreatNum = 0
    @_greatNum = 0
    @_goodNum = 0
    @_badNum = 0
    @_poorNum = 0
    @_comboPoint = 0
    @_pgreatIncVal = maxScore.pgreat / @_noteNum
    @_greatIncVal = maxScore.great / @_noteNum
    @_goodIncVal = maxScore.good / @_noteNum
    @_comboBonusFactor = maxScore.combo / (10 * (@_noteNum - 1) - 55)
    @_incValonUpdate = maxScore.good / @_noteNum / 10

    @_scoreLabel.init @_getDigits(maxScore.pgreat + maxScore.combo), 0
    @_comboLabel.init 4, 0

    @scheduleUpdate()

  get : ->
    score  : ~~(@_score.toFixed())
    combo  : @_maxCombo
    pgreat : @_pgreatNum
    great  : @_greatNum
    good   : @_goodNum
    bad    : @_badNum
    poor   : @_poorNum

  reflect : (judge) ->
    switch judge
      when "pgreat"
        @_score += @_pgreatIncVal
        @_combo++
        @_pgreatNum++
        #@_pgreatLabel.reflect @_pgreatNum

      when "great"
        @_score += @_greatIncVal
        @_combo++
        @_greatNum++
        #@_greatLabel.reflect @_greatNum

      when "good"
        @_score += @_goodIncVal
        @_combo++
        @_goodNum++
        #@_goodLabel.reflect @_goodNum

      when "bad"
        @_score += @_comboBonusFactor * @_comboPoint
        @_combo = 0
        @_comboPoint = 0
        @_badNum++
        #@_badLabel.reflect @_badNum
      else

    # full combo
    if @_combo is @_noteNum
      @_score += @_comboBonusFactor * @_comboPoint
      @_comboPoint = 0

    if 0 < @_combo <= 10
      @_comboPoint += @_combo - 1
    else if @_combo > 10
      @_comboPoint += 10

    if @_combo > @_maxCombo
      @_maxCombo = @_combo
    @_comboLabel.reflect @_maxCombo

    #@_dispScore = ~~(@_score.toFixed())
    #@_scoreLabel.reflect @_dispScore

  update : -> 
    if @_dispScore < ~~(@_score.toFixed())
      @_dispScore += @_incValonUpdate
      @_dispScore = if @_dispScore > ~~(@_score.toFixed()) then ~~(@_score.toFixed()) else @_dispScore
      @_scoreLabel.reflect @_dispScore

  _getDigits : (num)-> Math.log(num) / Math.log(10) + 1 | 0

module.exports = StatsLayer
