PreGame = require './pregame'
PostGame = require './postgame'
Game = require './game'

module.exports = class ConfectioneryCrush
  constructor: () ->
    @game = new Phaser.Game 600, 600, Phaser.AUTO
    @registerStates()

  registerStates: ->
    @game.state.add('preGame', new PreGame(@game), true)
    @game.state.add('game', new Game(@game))
    @game.state.add('postGame', new PostGame(@game))


game = new ConfectioneryCrush()
