class Game

  def initialize
  end

  def welcome_message
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    action = gets.chomp
  end

  def random_coordinate_generator
    #set orientation
    orientation = rand(2) #0 = horizontal, 1 = vertical

    # 1. generate board range based on ship length and orientation
    possible_coordinates = []
    @rows.each do |row|
      @columns.each do |column|
        possible_coordinates << row + column.to_s
      end
    end
    # 2. sample board range for anchor coordinate
    test_coordinates = []
    anchor_coordinate = coordinates.sample
    test_coordinates << anchor_coordinate

    # 3. generate ship coordinates from ship length, orietnation, anchor coordinate
    
    # 4. Check validation for generated coordiantes
    # 5a. If valid, set to coordinates for place
    # 5b. If not valid, re-do loop from #2 onwards


  end

end
