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


  # Randomly chooses which algorithm to generate random coordinates
  # and place ships on computer's board
  def cpu_board_setup
    generator = rand(2)
    start_time = Time.now

    if generator == 0
      algorithm = "Merali's"
      cruiser_coordinates = merali_algorithm(@cpu_board, @cpu_cruiser)
      @cpu_board.place(@cpu_cruiser, cruiser_coordinates)
      sub_coordinates = merali_algorithm(@cpu_board, @cpu_sub)
      @cpu_board.place(@cpu_sub, sub_coordinates)
    elsif generator == 1
      algorithm = "Griffith's"
      cruiser_coordinates = griffith_algorithm(@cpu_board, create_coordinate_array(@cpu_board, @cpu_cruiser))
      @cpu_board.place(@cpu_cruiser, cruiser_coordinates)
      sub_coordinates = griffith_algorithm(@cpu_board, create_coordinate_array(@cpu_board, @cpu_sub))
      @cpu_board.place(@cpu_sub, sub_coordinates)
    end

    sort_time = Time.now - start_time
    puts "It took me #{sort_time} seconds to place my two ships according to #{algorithm} algorithm.\n"
  end


  def player_board_setup
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."

    @player_board.render
    puts "Enter the squares for the Cruiser (3 spaces): "
    @player_board.place(@player_cruiser, get_user_coordinates(@player_cruiser))
    @player_board.render(true)

    puts "Enter the squares for the Submarine (2 spaces): "
    @player_board.place(@player_sub, get_user_coordinates(@player_sub))
  end


  # Validates user's coordinates for ship placement
  def get_user_coordinates(ship)
    correct = false

    while correct == false
      print "> "
      response = gets.chomp.split
      if @player_board.valid_placement?(ship, response)
        correct = true
      else
        puts "Those are invalid coordinates. Please try again."
      end
    end
    response
  end

  #Merali algorithm: Randomly select an anchor point on the Board
  #Generate a set of 4 possible coordinates based on that anchor point
  #Sample from these 4 coordinates until a valid set is found; if none is found,
  #re-sample from the board for a new anchor point
  def merali_algorithm(board, ship)
    anchor = board.cells.keys.sample
    ship_coordinates = []
    while !board.valid_placement?(ship, ship_coordinates)
      possible_coordinates = generate_possible_coordinates(ship, anchor)
      ship_coordinates = [anchor, possible_coordinates.sample]
      ship_coordinates.flatten!.sort!
    end
    return ship_coordinates
  end

  #Helper method to generate possible coordinates based on an anchor coordinate
  def generate_possible_coordinates(ship, anchor)
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
    return possible_coordinates
  end

  # Given a series of valid consecutive coordinates, rows and columns are added
  # based on a random seed that create an array of arrays of coordinate pairs.
  # These coordinates are validated by checking overlap and then a single coordinate is sampled.
  def griffith_algorithm(board, coord_array)
    seed = board.columns.to_a.map { |col| col - 1 }.sample # seed is a random num from 0 to col - 1
    coord_pairs = []
    coord_array.each do |array|
      if array[0].is_a? Integer
         coord_pairs << array.map do |coordinate|
          board.rows.to_a[seed] + coordinate.to_s
        end
      elsif array[0].is_a? String
        coord_pairs << array.map do |coordinate|
          coordinate + board.columns.to_a[seed].to_s
        end
      end
    end
    validated_coordinates = coord_pairs.select { |coord| !board.overlap?(coord) }
    validated_coordinates.sample
  end

  # Helper method to be used with #griffith_algorithm
  def create_coordinate_array(board, ship)
    #generate array of arrays of valid rows/cols
    consecutive_coordinates = []

    board.rows.to_a.each_cons(ship.length) do |row|
      consecutive_coordinates << row
    end
    board.columns.to_a.each_cons(ship.length) do |column|
      consecutive_coordinates << column
    end
    consecutive_coordinates
  end

  def play
    #while ships are not sunk, create turn
    while !cpu_all_ships_sunk? && !player_all_ships_sunk?
      turn = Turn.new(@cpu_board, @player_board)
      turn.display_boards
      turn.user_shoots
      turn.computer_shoots(turn.generate_computer_shot)
    end
    end_game
  end

  def end_game
    if cpu_all_ships_sunk?
      puts "You won!"
    elsif player_all_ships_sunk?
      puts "I won!"
    end
  end

  def cpu_all_ships_sunk?
    @cpu_sub.sunk? && @cpu_cruiser.sunk?
  end

  def player_all_ships_sunk?
    @player_sub.sunk? && @player_cruiser.sunk?
  end
end
