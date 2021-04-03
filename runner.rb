require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require './lib/turn'


# board = Board.new
# cruiser = Ship.new("Cruiser", 3)
# sub = Ship.new("Submarine", 2)
game = Game.new
game.welcome_message
game.player_board_setup
game.cpu_board_setup
game.play
