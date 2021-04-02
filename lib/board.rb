require_relative 'board'
require_relative 'cell'
require_relative 'ship'
require 'pry'

class Board
  # Note: added rows and columns for pry session
  attr_reader :cells, :rows, :columns

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

#ADD helper method to run valid_coordinate? on array of coordinates
  def valid_coordinates?(coordinates)
    coordinates.all? { |coord| valid_coordinate?(coord) }
  end

#ADD helper method to parse coordinates into rows
  def parse_rows(coordinates)
    rows = []
    coordinates.each do |coordinate|
      rows << coordinate[0]
    end
    return rows
  end

#ADD helper method to parse coordinates into columns
  def parse_columns(coordinates)
    columns = []
    coordinates.each do |coordinate|
      columns << coordinate[1].to_i
    end
    return columns
  end

  def valid_placement?(ship, coordinates)
    # Method checks whether number of elements is equal to ship length
    # and then verifies that all coordinates are valid


    # #START CODE COMMENT
    # if ship.length == coordinates.count && !overlap?(coordinates) # overlap? is negated
    #   if valid_coordinates?(coordinates)

      # This section parses the input coordinates and creates
      # two separate arrays of rows and columns.
      # NOTE: could be refactored into separate helper method later

      #START CODE COMMENT
        # rows = []
        # columns = []
        # coordinates.each do |coordinate|
        #   rows << coordinate[0]
        #   columns << coordinate[1].to_i
        # end

      # Conditional flow control begins here:
      # Logic is either rows or columns must be consecutive
      # and the other must have static values. For example:
      # In the coordinates [A1, A2, A3], row (A) stays static and column (1, 2, 3) increments
      # Note: Coordinates will be entered L->R or T->B order

      #START CODE COMMENT
    #     if check_consecutive(ship, rows) && check_static(columns)
    #       true
    #     elsif check_consecutive(ship, columns) && check_static(rows)
    #       true
    #     else
    #       false
    #     end
    #   else
    #     false
    #   end
    # else
    #   false
    # end

    #REPLACEMENT USING HELPER METHODS:
    length_correct = (ship.length == coordinates.count)
    no_overlap = !overlap?(coordinates)
    on_board = valid_coordinates?(coordinates)
    parsed_rows = parse_rows(coordinates)
    parsed_columns = parse_columns(coordinates)
    horizontal_consecutive = check_consecutive(ship, parsed_columns) && check_static(parsed_rows)
    vertical_consecutive = check_consecutive(ship, parsed_rows) && check_static(parsed_columns)

    length_correct && no_overlap && on_board && (horizontal_consecutive || vertical_consecutive)
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
  end

  # This method uses the #all? enumerable to check to see
  # if all parsed coordinates are equal to each other
  def check_static(parsed_coordinates)
    parsed_coordinates.all? { |coordinate| coordinate == parsed_coordinates[0]}
  end

  def overlap?(coordinates)
    coordinates.any? { |coordinate| @cells[coordinate].ship != nil }
  end

  def place(ship, coordinates)
    # iterate over each coordinate pair and #place_ship using @cells hash
    #Add an all statement here to confirm that all coordiantes pass valid_coordinate
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end

  def render(value = false)
    print "  1 2 3 4 \n"
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
  # binding.pry
end
