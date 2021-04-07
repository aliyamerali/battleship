require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require './lib/turn'
require './lib/dimension'

keep_playing = true

while keep_playing == true
  puts '  ___   _ _____ _____ _    ___ ___ _  _ ___ ___ '
  puts ' | _ ) /_\_   _|_   _| |  | __/ __| || |_ _| _ \ '
  puts ' | _ \/ _ \| |   | | | |__| _|\__ \ __ || ||  _/ '
  puts ' |___/_/ \_\_|   |_| |____|___|___/_||_|___|_|  '

  puts "Enter p to play. Enter q to quit."
  player_choice = gets.chomp
  if player_choice == "p"
    game = Game.new(Dimension.get_board_dimensions)
    game.cpu_board_setup
    game.player_board_setup
    game.play
  elsif player_choice == "q"
    keep_playing = false
  else
    puts "Incorrect user input."
  end
end

puts "Thanks for playing."
