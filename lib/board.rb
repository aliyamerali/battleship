class Board
  attr_reader :cells, :rows, :columns

  def initialize(dimension = 4)
    dimension = dimension
    @rows = "A"..("A".ord + dimension-1).chr
    @columns = 1..dimension
    generate_board_hash
  end

  def generate_board_hash
    coordinates = []
    @rows.each do |row|
      @columns.each do |column|
        coordinates << row + column.to_s
      end
    end

    @cells = Hash.new
    coordinates.map do |coordinate|
      @cells[coordinate] = Cell.new(coordinate)
    end

    @cells
  end

  def valid_coordinate?(coordinate)
    @cells[coordinate] != nil
  end

  def valid_coordinates?(coordinates)
    coordinates.all? { |coord| valid_coordinate?(coord) }
  end

  def valid_placement?(ship, coordinates)
    player_input_valid?(ship, coordinates) &&
    (is_horizontal?(ship, coordinates) || is_vertical?(ship, coordinates))
  end

  def player_input_valid?(ship, coordinates)
    (ship.length == coordinates.count) &&
    valid_coordinates?(coordinates) &&
    !overlap?(coordinates)
  end

  def is_horizontal?(ship, coordinates)
    consecutive?(ship, parse_columns(coordinates)) &&
    matching_coordinate?(parse_rows(coordinates))
  end

  def is_vertical?(ship, coordinates)
    consecutive?(ship, parse_rows(coordinates)) &&
    matching_coordinate?(parse_columns(coordinates))
  end

  def consecutive?(ship, parsed_coordinates)
    consecutive_coordinates = []

    @rows.to_a.each_cons(ship.length) do |row|
      consecutive_coordinates << row
    end

    @columns.to_a.each_cons(ship.length) do |column|
      consecutive_coordinates << column
    end

    consecutive_coordinates.include?(parsed_coordinates)
  end

  def matching_coordinate?(parsed_coordinates)
    parsed_coordinates.all? { |coordinate| coordinate == parsed_coordinates[0]}
  end

  def overlap?(coordinates)
    coordinates.any? { |coordinate| @cells[coordinate].ship != nil }
  end

  def parse_rows(coordinates)
    coordinates.map do |coordinate|
      coordinate[0]
    end
  end

  def parse_columns(coordinates)
    coordinates.map do |coordinate|
      coordinate[1].to_i
    end
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    else
      puts "There has been an error in ship placement!"
      false
    end
  end

  def render(value = false)
    print "  "
    @columns.each do |col|
      print col.to_s + " "
    end
    print "\n"

    if value == true
      @rows.each do |row|
        print row
        @columns.each do |col|
          print " " + @cells[row + col.to_s].render(true)
        end
        print " \n"
      end
    else
      @rows.each do |row|
        print row
        @columns.each do |col|
          print " " + @cells[row + col.to_s].render
        end
        print " \n"
      end
    end
  end

end
