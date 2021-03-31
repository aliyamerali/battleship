class Board
  attr_reader :cells

  def initialize
    # Making column and row dimension as variables
    # so easier to make dimensions change down the line
    column_dimension = 4
    row_dimension = column_dimension
    rows = "A".."D"
    columns = 1..column_dimension
    coordinates = []

    # Iterate over row and column ranges to concatenate and push into array of coordinates
    rows.each do |row|
      columns.each do |column|
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
    ship.length == coordinates.count #ship @length should be same as count of coordinates

    # either rows or columns needs to increment by 1
    # if rows.include?(coordinates[0][0]) 
  end
end
