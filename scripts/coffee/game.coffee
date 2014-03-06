FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game

  preload: ->
    @game.load.image('sq', '/assets/images/test-sprite.png')


  create: ->
    # @game.physics.gravity.y = 250
    # @game.physics.setBoundsToWorld()
    @squares =  @game.add.group()
    @squares.createMultiple(64, 'sq')
    @squares.setAll('outOfBoundsKill', true)
    @squares.forEach(@addSquare, this, false)
    # @squares.setAll('body.bounce.x', 0)
    # @squares.setAll('body.bounce.y', 0)
    # @squares.setAll('body.minBounceVelocity', 0)

  update: ->
    # @game.physics.collide(@squares)


  render: ->

  addSquare: (sq) ->
    idx = @squares.getIndex(sq)
    x = (idx % 8) * 75
    y = (Math.floor(idx / 8)) * 75
    sq.reset(x,y)
    # sq.body.collideWorldBounds=true
    # sq.body.gravity.y = 50
    # sq.body.setRectangle(75, 75, 0, 0)
    sq.inputEnabled = true
    sq.input.pixelPerfect = true
    sq.events.onInputUp.add(@squareTouched, this)

  squareTouched: (sq) ->
    gridCoord = @getGridCoord(sq)
    effectedSqs = @getSquaresAbove(sq, gridCoord)
    sq.kill()
    effectedSqs.forEach( (sq) =>
      tween = @game.add.tween(sq)
      tween
        .to({y: sq.y + 75}, 300, Phaser.Easing.Bounce.None)
        .start()
    )

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
      squaresAbove.push(@getSquareAt({x:xPos, y:yPos}))
    return squaresAbove

  getSquareAt: (coord) ->
    foundSq = null
    @squares.forEachAlive( (sq) =>
      if sq.x == coord.x and sq.y == coord.y
        foundSq = sq
    , this)
    return foundSq
