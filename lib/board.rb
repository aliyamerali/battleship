class Board
  attr_reader :cells, :rows, :columns

  def initialize(dimension = 4)
    column_dimension = dimension
    row_dimension = dimension
    @rows = "A"..("A".ord + row_dimension-1).chr
    @columns = 1..column_dimension
    generate_board_hash
  end

  # Helper method that returns the @cells hash of board coordinates
  def generate_board_hash
    coordinates = []
    @cells = Hash.new
    # Iterate over row and column ranges to concatenate and push into array of coordinates
    @rows.each do |row|
      @columns.each do |column|
        coordinates << row + column.to_s
      end
    end
    # We iterate over the coordinates array to populate the cells hash
    coordinates.map do |coordinate|
      @cells[coordinate] = Cell.new(coordinate)
    end
    @cells
  end

  def valid_coordinate?(coordinate)
    @cells[coordinate] != nil
  end

  # Helper method to run valid_coordinate? on array of coordinates
  def valid_coordinates?(coordinates)
    coordinates.all? { |coord| valid_coordinate?(coord) }
  end

  def valid_placement?(ship, coordinates)
    # Note: Logic only works when coordinates entered from L->R or T->B
    player_input_valid?(ship, coordinates) &&
    (is_horizontal?(ship, coordinates) || is_vertical?(ship, coordinates))
  end

  def player_input_valid?(ship, coordinates)
    (ship.length == coordinates.count) &&
    valid_coordinates?(coordinates) &&
    !overlap?(coordinates)
  end

  # When columns are consecutive and rows stay the same, placement is horizontal
  def is_horizontal?(ship, coordinates)
    consecutive?(ship, parse_columns(coordinates)) &&
    on_axis?(parse_rows(coordinates))
  end

  # When rows are consecutive and columns stay the same, placement is is_vertical
  def is_vertical?(ship, coordinates)
    consecutive?(ship, parse_rows(coordinates)) &&
    on_axis?(parse_columns(coordinates))
  end

  # Helper method is flexible enough to test rows or columns are consecutive
  def consecutive?(ship, parsed_coordinates)
    #generate array of arrays of valid rows/cols
    consecutive_coordinates = []

    @rows.to_a.each_cons(ship.length) do |row|
      consecutive_coordinates << row
    end

    @columns.to_a.each_cons(ship.length) do |column|
      consecutive_coordinates << column
    end

    consecutive_coordinates.include?(parsed_coordinates)
  end

  # This method uses the #all? enumerable to check to see
  # if all parsed coordinates are equal to each other (on the same axis)
  def on_axis?(parsed_coordinates)
    parsed_coordinates.all? { |coordinate| coordinate == parsed_coordinates[0]}
  end

  def overlap?(coordinates)
    coordinates.any? { |coordinate| @cells[coordinate].ship != nil }
  end

  # Helper method to parse coordinates into rows
  def parse_rows(coordinates)
    rows = []
    coordinates.each do |coordinate|
      rows << coordinate[0]
    end
    rows
  end

  # Helper method to parse coordinates into columns
  def parse_columns(coordinates)
    columns = []
    coordinates.each do |coordinate|
      columns << coordinate[1].to_i
    end
    columns
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
    # print "  1 2 3 4 \n"
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
