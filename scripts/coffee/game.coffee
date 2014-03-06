FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game

  preload: ->
    @game.load.image('sq', '/assets/images/test-sprite.png')


  create: ->
    @game.physics.gravity.y = 250
    #@game.physics.setBoundsToWorld()
    @squares =  @game.add.group()
    @squares.createMultiple(64, 'sq')
    @squares.setAll('outOfBoundsKill', true)
    @squares.forEach(@addSquare, this, false)

  update: ->

  render: ->

  addSquare: (sq) ->
    idx = @squares.getIndex(sq)
    x = (idx % 8) * 75
    y = (Math.floor(idx / 8)) * 75
    sq.reset(x,y)
    sq.body.collideWorldBounds=true
    sq.body.gravity.y = 50
    #console.log(sq)
