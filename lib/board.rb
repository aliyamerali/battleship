class Board
  attr_reader :cells

  def initialize
    # Making column and row dimension as variables
    # so easier to make dimensions change down the line
    column_dimension = 4
    row_dimension = column_dimension
    @rows = "A".."D"
    @columns = 1..column_dimension
    coordinates = []

    # Iterate over row and column ranges to concatenate and push into array of coordinates
    @rows.each do |row|
      @columns.each do |column|
        coordinates << row + column.to_s
      end
    end


    @cells = Hash.new
    # We iterate over the coordinates array to populate the cells hash
    coordinates.each do |coordinate|
      @cells[coordinate] = Cell.new(coordinate)
    end

  end

  def valid_coordinate?(coordinate)
    @cells[coordinate] != nil
  end

  def valid_placement?(ship, coordinates)
    # put in an if
    # ship.length == coordinates.count #ship @length should be same as count of coordinates

    # This section parses the input coordinates and creates
    # two separate arrays of rows and columns.
    # NOTE: could be refactored into separate helper method later
    rows = []
    columns = []
    coordinates.each do |coordinate|
      rows << coordinate[0]
      columns << coordinate[1]
    end

    # Conditional flow control begins here:
    # Logic is either rows or columns must be consecutive
    # and the other must have static values. For example:
    # In the coordinates [A1, A2, A3], row (A) stays static and column (1, 2, 3) increments
    # Note: Coordinates will be entered L->R or T->B order
    if check_consecutive(ship, rows) && check_static(columns)
      true
    elsif check_consecutive(ship, columns) && check_static(rows)
      true
    else
      false
    end

  end

  # Helper method is flexible enough to test rows or columns are consecutive
  def check_consecutive(ship, parsed_coordinates)
    #generate array of arrays of valid rows/cols
    consecutive_coordinates = []

    @rows.to_a.each_cons(ship.length) do |row|
      consecutive_coordinates << row
    end

    @columns.to_a.each_cons(ship.length) do |column|
      consecutive_coordinates << column
    end

    consecutive_coordinates.include?(parsed_coordinates)
    #expect to return a boolean true or false
  end

  # This method uses the #all? enumerable to check to see
  # if all parsed coordinates are equal to each other
  def check_static(parsed_coordinates)
    parsed_coordinates.all? { |coordinate| coordinate == parsed_coordinates[0]}
  end

end
