JudgeTest = cc.Class.extend
  start : ->
    describe 'judge class test', ->
      @timeout 10000
      Judge  = require '../../src/judge'
      expect = chai.expect

      it 'judge test', ->
        console.log "start"

        pgreatNum = 0
        greatNum = 0
        goodNum = 0
        badNum = 0

        judge = new Judge
          pgreat : 0.05
          great  : 0.1
          good   : 0.2

        onPgreat = -> pgreatNum++
        onGreat  = -> greatNum++
        onGood   = -> goodNum++
        onBad    = -> badNum++

        judge.addEventListener 'pgreat', onPgreat
        judge.addEventListener 'great', onGreat
        judge.addEventListener 'good', onGood
        judge.addEventListener 'bad', onBad

        judge.judge 0.049
        expect(pgreatNum).to.be.equal 1
        judge.judge 0.05
        expect(greatNum).to.be.equal 1
        judge.judge 0.09
        expect(greatNum).to.be.equal 2
        judge.judge 0.1
        expect(goodNum).to.be.equal 1
        judge.judge 0.19
        expect(goodNum).to.be.equal 2
        judge.judge 0.2
        expect(badNum).to.be.equal 1

module.exports = JudgeTest


