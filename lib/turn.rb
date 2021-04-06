class Turn
attr_accessor :player_shot, :cpu_shot #These instance variables were only given
                                      #attr_accessors for testing purposes

  def initialize(cpu_board, player_board)
    @cpu_board = cpu_board
    @player_board = player_board
  end

  def display_boards
    puts "=============COMPUTER BOARD============="
    @cpu_board.render
    puts "==============PLAYER BOARD=============="
    @player_board.render(true)
  end

  def player_shoots
    shot_is_fired = false
    puts "Enter the coordinate for your shot:"
    while shot_is_fired == false
      @player_shot = gets.chomp
      if @cpu_board.valid_coordinate?(@player_shot)
        if @cpu_board.cells[@player_shot].fired_upon? == true
          puts "You have already fired on that coordinate. Please try again."
        else
          @cpu_board.cells[@player_shot].fire_upon
          shot_is_fired = true
        end
      else
        puts "Please enter a valid coordinate."
      end
    end
  end

  def generate_computer_shot
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
    puts "Your shot on #{@player_shot} #{status_conversion[@cpu_board.cells[@player_shot].render]}."
    puts "My shot on #{@cpu_shot} #{status_conversion[@player_board.cells[@cpu_shot].render]}."
  end
end
