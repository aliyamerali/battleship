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
    # action = gets.chomp
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
    @player_board.place(@player_sub, ["D1","D2"])#get_user_coordinates(@player_sub))
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
    generator = 0 #rand(2) #0 = am, 1 = jg
    if generator = 0
      cruiser_coordinates = am_random_coordinate_generator(@cpu_board, @cpu_cruiser)
      @cpu_board.place(@cpu_cruiser, cruiser_coordinates)
      sub_coordinates = am_random_coordinate_generator(@cpu_board, @cpu_sub)
      @cpu_board.place(@cpu_sub, sub_coordinates)
    else
      cruiser_coordinates = jg_random_coordinate_generator(@cpu_board, @cpu_cruiser)
      @cpu_board.place(@cpu_cruiser, cruiser_coordinates)
      sub_coordinates = jg_random_coordinate_generator(@cpu_board, @cpu_sub)
      @cpu_board.place(@cpu_sub, sub_coordinates)
    end
  end


  def am_random_coordinate_generator(board, ship)
    anchor = board.cells.keys.sample
    #Make array of 4 possible coordinate paths for cruiser
    if ship.length == 3
      possible_coordinates = [
        [anchor[0]+(anchor[1].to_i - 1).to_s, anchor[0]+(anchor[1].to_i - 2).to_s],
        [anchor[0]+(anchor[1].to_i + 1).to_s, anchor[0]+(anchor[1].to_i + 2).to_s],
        [(anchor[0].ord - 1).chr+anchor[1], (anchor[0].ord - 2).chr+anchor[1]],
        [(anchor[0].ord + 1).chr+anchor[1], (anchor[0].ord + 2).chr+anchor[1]]
      ]
    elsif ship.length == 2
        possible_coordinates = [
          [anchor[0]+(anchor[1].to_i - 1).to_s],
          [anchor[0]+(anchor[1].to_i + 1).to_s],
          [(anchor[0].ord - 1).chr+anchor[1]],
          [(anchor[0].ord + 1).chr+anchor[1]]
        ]
      end

    #Randomly select one of these possible coordinates, test for valid placement, repeat until valid
    ship_coordinates = []
    while !board.valid_placement?(ship, ship_coordinates)
      ship_coordinates = [anchor, possible_coordinates.sample]
      ship_coordinates.flatten!.sort!
    end
    return ship_coordinates
  end

#TO RENAME: jg_random_coordinate_generator(board, ship)
  def generate_ship_possibilities(board, ship)
    #generate array of arrays of valid rows/cols
    consecutive_coordinates = []

    board.rows.to_a.each_cons(ship.length) do |row|
      consecutive_coordinates << row
    end
    board.columns.to_a.each_cons(ship.length) do |column|
      consecutive_coordinates << column
    end

    coord_pairs = []
    consecutive_coordinates.each do |array|
      #seed = consecutive_coordinates.sample
      if array[0].is_a? Integer
         coord_pairs << array.map do |coordinate|
          board.rows.to_a.sample + coordinate.to_s
        end
      elsif array[0].is_a? String
        coord_pairs << array.map do |coordinate|
          coordinate + board.columns.to_a.sample.to_s
        end
      end
    end
    coord_pairs
    #require 'pry';binding.pry
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
