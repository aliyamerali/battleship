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

  def check_consecutive(ship, coordinates_to_check) #coordinate_type is either rows or cols
    #generate array of arrays of valid rows/cols
    consecutive_coordinates = []

    @rows.to_a.each_cons(ship.length) do |row|
      consecutive_coordinates << row
    end

    @columns.to_a.each_cons(ship.length) do |column|
      consecutive_coordinates << column
    end

    consecutive_coordinates.include?(coordinates_to_check)
    #expect to return a boolean true or false
  end

  def valid_placement?(ship, coordinates)
    # put in an if
    # ship.length == coordinates.count #ship @length should be same as count of coordinates

    # either rows or columns needs to increment by 1
    # coordinates will be entered L->R or T->B order
    # row_start = coordinates[0][0] #Letter
    # col_start = coordinates[0][1] #Number

    rows = []
    cols = []
    coordinates.each do |coordinate|
      rows << coordinate[0]
      cols << coordinate[1]
    end

    # require 'pry'; binding.pry

    if check_consecutive(ship, rows)
        # check that columns are the same
        puts "check that the cols are the same!"
    elsif check_consecutive(ship, cols)
        #check that rows are the same
        puts "check that the rows are the same!"
    else
      return false
    end

  end
end
