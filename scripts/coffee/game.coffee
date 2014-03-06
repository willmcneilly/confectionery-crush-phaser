FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game

  preload: ->
    @game.load.image('sq', '/assets/images/test-sprite.png')


  create: ->
    @squares =  @game.add.group()
    @squares.createMultiple(94, 'sq')
    @squares.setAll('outOfBoundsKill', true)
    @squares.forEach(@addSquare, this, false)

  update: ->
    # @game.physics.collide(@squares)


  render: ->

  addSquare: (sq) ->
    idx = @squares.getIndex(sq)
    x = (idx % 8) * 75
    y = (Math.floor(idx / 8)) * 75
    sq.reset(x,y)
    sq.inputEnabled = true
    sq.input.pixelPerfect = true
    sq.events.onInputUp.add(@squareTouched, this)

  squareTouched: (sq) ->
    sq.inputEnabled = false
    gridCoord = @getGridCoord(sq)
    effectedSqs = @getSquaresAbove(sq, gridCoord)
    killSqTween = @game.add.tween(sq)
      .to({alpha: 0}, 300, Phaser.Easing.Bounce.None)
      .start()
      .onComplete.add(->
        sq.kill()
      , this)

    effectedSqs.forEach( (sq) =>
      tween = @game.add.tween(sq)
      tween
        .to({y: sq.y + 75}, 200, Phaser.Easing.Bounce.None)
        .start()
    )
    @addNewSquare(gridCoord.x)

  getGridCoord: (sq) ->
    x = sq.x
    y = sq.y
    {
      x : sq.x / 75 + 1
      y : sq.y / 75 + 1
    }

  getSquaresAbove: (sq, gridCoord) ->
    xPos = sq.x
    squaresAbove = []
    for num in [gridCoord.y - 1...0]
      yPos = sq.y - (num * 75)
      foundSq = @getSquareAt({x:xPos, y:yPos})
      unless foundSq == null
        squaresAbove.push(foundSq)
    return squaresAbove

  getSquareAt: (coord) ->
    foundSq = null
    @squares.forEachAlive( (sq) =>
      if sq.x == coord.x and sq.y == coord.y
        foundSq = sq
    , this)
    return foundSq

  addNewSquare: (x) ->
    xPos = (x - 1) * 75
    sq = @squares.getFirstDead()
    sq.alpha = 0
    sq.reset(xPos, 0)
    sq.inputEnabled = true
    sq.input.pixelPerfect = true
    sq.events.onInputUp.add(@squareTouched, this)
    addSquareTween = @game.add.tween(sq)
      .to({alpha: 1}, 300, Phaser.Easing.Bounce.None)
      .start()
