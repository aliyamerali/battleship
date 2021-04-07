class Dimension

  def self.get_board_dimensions
    puts "How big a board would you like to play on?"
    puts "The board will be a square, with dimensions of at least 3x3."
    puts "Enter an integer dimension for your board:"
    dimension = gets.chomp.to_i

    while dimension < 3
      puts "That is an invalid dimension. Please enter a single integer value of at least 3."
      dimension = gets.chomp.to_i
    end
    dimension
  end

end
