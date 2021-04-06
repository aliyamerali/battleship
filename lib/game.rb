class Game
  attr_reader :cpu_board, :player_board, :ships

  def initialize
    @cpu_board = Board.new
    @player_board = Board.new
    generate_ships_hash
  end

  def generate_ships_hash
    @ships = Hash.new

    players = { :player => '', :cpu => '' }

    players.each do |key, value|
      @ships[key] = {
        submarine: Ship.new("Submarine", 2),
        cruiser: Ship.new("Cruiser", 3)
      }
    end
    @ships
  end

  # Randomly chooses which algorithm to generate random coordinates
  # and place ships on computer's board
  def cpu_board_setup
    cpu_cruiser = @ships[:cpu][:cruiser]
    cpu_sub = @ships[:cpu][:submarine]
    start_time = Time.now
    branch_decision = rand(2)

    if branch_decision == 0
      algorithm = "Merali's"
      @cpu_board.place(cpu_cruiser, merali_algorithm(@cpu_board, cpu_cruiser))
      @cpu_board.place(cpu_sub, merali_algorithm(@cpu_board, cpu_sub))
    elsif branch_decision == 1
      algorithm = "Griffith's"
      @cpu_board.place(cpu_cruiser, griffith_algorithm(@cpu_board, cpu_cruiser))
      @cpu_board.place(cpu_sub, griffith_algorithm(@cpu_board, cpu_sub))
    end
    puts "It took me #{Time.now - start_time} seconds to place my two ships according to #{algorithm} algorithm.\n"
  end


  def player_board_setup
    cruiser = @ships[:player][:cruiser]
    sub = @ships[:player][:submarine]
    #require 'pry'; binding.pry

    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."

    @player_board.render
    puts "Enter the squares for the Cruiser (3 spaces): "
    @player_board.place(cruiser, get_player_coordinates(cruiser))

    @player_board.render(true)
    puts "Enter the squares for the Submarine (2 spaces): "
    @player_board.place(sub, get_player_coordinates(sub))
  end


  # Validates player's coordinates for ship placement
  def get_player_coordinates(ship)
    response = gets.chomp.split
    while @player_board.valid_placement?(ship, response) == false
      puts "Those are invalid coordinates. Please try again"
      response = gets.chomp.split
    end
    response
  end

  #Merali algorithm: Randomly select an anchor point on the Board
  #Generate a set of 4 possible coordinates based on that anchor point
  #Sample from these 4 coordinates until a valid set is found; if none is found,
  #re-sample from the board for a new anchor point
  def merali_algorithm(board, ship)
    ship_coordinates = []
    while !board.valid_placement?(ship, ship_coordinates)
      anchor = board.cells.keys.sample
      possible_coordinates = generate_possible_coordinates(ship, anchor)
      if sample_possible_coordinates(board, ship, possible_coordinates) != nil
        ship_coordinates = sample_possible_coordinates(board, ship, possible_coordinates)
      end
    end
    ship_coordinates
  end


  #Helper method to iterate through possible coordinates generated
  def sample_possible_coordinates(board, ship, possible_coordinates)
    ship_coordinates = possible_coordinates.find_all do |coordinates|
      board.valid_placement?(ship, coordinates)
    end
    ship_coordinates.sample
  end


  #Helper method to generate possible coordinates based on an anchor coordinate
  def generate_possible_coordinates(ship, anchor)
    if ship.length == 3
      possible_coordinates = [
        [anchor, anchor[0]+(anchor[1].to_i - 1).to_s, anchor[0]+(anchor[1].to_i - 2).to_s],
        [anchor, anchor[0]+(anchor[1].to_i + 1).to_s, anchor[0]+(anchor[1].to_i + 2).to_s],
        [anchor, (anchor[0].ord - 1).chr+anchor[1], (anchor[0].ord - 2).chr+anchor[1]],
        [anchor, (anchor[0].ord + 1).chr+anchor[1], (anchor[0].ord + 2).chr+anchor[1]]
      ]
    elsif ship.length == 2
        possible_coordinates = [
          [anchor, anchor[0]+(anchor[1].to_i - 1).to_s],
          [anchor, anchor[0]+(anchor[1].to_i + 1).to_s],
          [anchor, (anchor[0].ord - 1).chr+anchor[1]],
          [anchor, (anchor[0].ord + 1).chr+anchor[1]]
        ]
    end
    return possible_coordinates
  end

  # Given a series of valid consecutive coordinates, rows and columns are added
  # based on a random seed that create an array of arrays of coordinate pairs.
  # These coordinates are validated by checking overlap and then a single coordinate is sampled.
  def griffith_algorithm(board, ship)
    seed = board.columns.to_a.map { |col| col - 1 }.sample # seed is a random num from 0 to col - 1
    coord_pairs = []
    coord_array = create_coordinate_array(board, ship)

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
    while !cpu_game_over? && !player_game_over?
      turn = Turn.new(@cpu_board, @player_board)
      turn.display_boards
      turn.player_shoots
      turn.generate_computer_shot
      turn.display_results
    end
    puts end_game
  end

  def end_game
    if cpu_game_over?
      "You won!"
    elsif player_game_over?
      "I won!"
    end
  end

  def cpu_game_over?
    @ships[:cpu][:submarine].sunk? &&
    @ships[:cpu][:cruiser].sunk?
  end

  def player_game_over?
    @ships[:player][:submarine].sunk? &&
    @ships[:player][:cruiser].sunk?
  end
end
