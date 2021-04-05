class Turn

  # take in a shot
  # update the board based on the shot (update the ship object within a cell object withinthe board)
    # uses .fire_upon method within Cell class
  # give feedback to players about their shots

  def initialize(cpu_board, player_board)
    @cpu_board = cpu_board
    @player_board = player_board
  end

  def display_boards
    puts "=============COMPUTER BOARD============="
    @cpu_board.render(true)
    puts "==============PLAYER BOARD=============="
    @player_board.render(true)
  end

  def user_shoots
    puts "Enter the coordinate for your shot:"
    @user_shot = gets.chomp
    while !@cpu_board.valid_coordinate?(@user_shot)
      puts "Please enter a valid coordinate:"
      @user_shot = gets.chomp
      # if !@cpu_board.cells[@user_shot].fired_upon?
      #   @cpu_board.cells[@user_shot].fire_upon
      # else
      #   puts "You've already fired upon this cell."
      #   shot = []
      # end
    end
    @cpu_board.cells[@user_shot].fire_upon
  end

  def generate_computer_shot
    # generate a random shot, not fire on a space that has already been fired on.
    @cpu_shot = @player_board.cells.keys.sample
    while @player_board.cells[@cpu_shot].fired_upon?
      @cpu_shot = @player_board.cells.keys.sample
    end
    @cpu_shot
  end

  def computer_shoots(shot)
    @player_board.cells[shot].fire_upon
  end

  def display_results
    status_conversion = {
      "M" => "was a miss",
      "H" => "was a hit",
      "X" => "sank a ship"
    }
    puts "Your shot on #{@user_shot} #{status_conversion[@cpu_board.cells[@user_shot].render]}."
    puts "My shot on #{@cpu_shot} #{status_conversion[@player_board.cells[@cpu_shot].render]}."
  end
end
