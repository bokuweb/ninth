StatsLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()
    Numerallabel = require './numeralLabel'
    @_scoreLabel = new NumeralLabel @_skin.score
    @_comboLabel =  new NumeralLabel @_skin.comboNum
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

    @_scoreLabel.init @_getDigits(maxScore.pgreat + maxScore.combo), 0
    @_scoreLabel.x = cc.screenSize.width / 2 + @_skin.score.x
    @_scoreLabel.y = cc.screenSize.height - @_skin.score.y

    @_comboLabel.init 4, 0
    @_comboLabel.x = cc.screenSize.width / 2 + @_skin.comboNum.x
    @_comboLabel.y = cc.screenSize.height - @_skin.comboNum.y

  get : ->
    score  : @_dispScore
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
        @_pgreatLabel.reflect @_pgreatNum

      when "great"
        @_score += @_greatIncVal
        @_combo++
        @_greatNum++
        @_greatLabel.reflect @_greatNum

      when "good"
        @_score += @_goodIncVal
        @_combo++
        @_goodNum++
        @_goodLabel.reflect @_goodNum

      when "bad"
        @_score += @_comboBonusFactor * @_comboPoint
        @_combo = 0
        @_comboPoint = 0
        @_badNum++
        @_badLabel.reflect @_badNum
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
    @_comboLabel.reflect @_combo

    @_dispScore = ~~(@_score.toFixed())
    @_scoreLabel.reflect @_dispScore


  _getDigits : (num)-> Math.log(num) / Math.log(10) + 1 | 0

module.exports = StatsLayer
