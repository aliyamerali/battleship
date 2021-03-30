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


  end


end
