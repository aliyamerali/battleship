# require './lib/turn'

class Game

  def initialize
    @cpu_board = Board.new
    @player_board = Board.new
    # Add hash in future as container for ships
    @player_cruiser = Ship.new("Cruiser", 3)
    @player_sub = Ship.new("Submarine", 2)
    @cpu_cruiser = Ship.new("Cruiser", 3)
    @cpu_sub = Ship.new("Submarine", 2)

  end

  def welcome_message
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    action = gets.chomp
  end

  def player_board_setup
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."

    @player_board.render
    puts "Enter the squares for the Cruiser (3 spaces): "
    @player_board.place(@player_cruiser, ["A1","A2", "A3"])#get_user_coordinates(@player_cruiser))
    @player_board.render(true)

    puts "Enter the squares for the Submarine (2 spaces): "
    @player_board.place(@player_sub, ["B1", "B2"]) #get_user_coordinates(@player_sub))
  end

  def get_user_coordinates(ship)
    correct = false

    while correct == false
      print "> "
      response = gets.chomp.split
      if @player_board.valid_placement?(ship, response)
        correct = true
        puts "Hooray"
      else
        puts "Those are invalid coordinates. Please try again."
      end
    end
    return response
  end

  def cpu_board_setup
    coord1 = ["A1", "A2", "A3"]
    coord2 = ["C1", "D1"]
    @cpu_board.place(@cpu_cruiser, coord1)
    @cpu_board.place(@cpu_sub, coord2)
  end

  def random_coordinate_generator
    #set orientation
    orientation = rand(2) #0 = horizontal, 1 = vertical

    # 1. generate board range based on ship length and orientation
    possible_coordinates = []
    @rows.each do |row|
      @columns.each do |column|
        possible_coordinates << row + column.to_s
      end
    end
    # 2. sample board range for anchor coordinate
    test_coordinates = []
    anchor_coordinate = coordinates.sample
    test_coordinates << anchor_coordinate

    # 3. generate ship coordinates from ship length, orietnation, anchor coordinate

    # 4. Check validation for generated coordiantes
    # 5a. If valid, set to coordinates for place
    # 5b. If not valid, re-do loop from #2 onwards
  end

  def play
    #while ships are not sunk, create turn
    while !cpu_all_ships_sunk? && !player_all_ships_sunk?
      puts "cpu_all_ships_sunk? == false evaluates to #{cpu_all_ships_sunk? == false}"
      puts "player_all_ships_sunk? == false evalutes to #{player_all_ships_sunk? == false}"
      puts @cpu_sub.health
      turn = Turn.new(@cpu_board, @player_board)
      turn.display_boards
      turn.user_shoots
      # require 'pry'; binding.pry
    end

    puts "game over"
    #once all of one players ships are sunk, call an end_game helper that declares winner!
  end

  def cpu_all_ships_sunk?
    @cpu_sub.sunk? && @cpu_cruiser.sunk?
  end

  def player_all_ships_sunk?
    @player_sub.sunk? && @player_cruiser.sunk?
  end
end
