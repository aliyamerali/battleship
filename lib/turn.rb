class Turn
attr_accessor :player_shot, :cpu_shot,
              :target_mode, :hot_spot

  def initialize(cpu_board, player_board, cpu_state)
    @cpu_board = cpu_board
    @player_board = player_board
    @target_mode = cpu_state[:state]
    @hot_spot = cpu_state[:target]
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

  def cpu_firing_procedure
    if @target_mode == true
      cpu_shot_validation(targeted_area(@player_board))
      computer_shoots(@cpu_shot)
      if @player_board.cells[@hot_spot].render == "X"
        deactivate_target_mode
      end
    else
      cpu_shot_validation(@player_board.cells.keys)
      computer_shoots(@cpu_shot)
      if @player_board.cells[@cpu_shot].render == "H"
        activate_target_mode
      end
    end
  end

  def cpu_shot_validation(target_area)
    @cpu_shot = target_area.sample
    while @player_board.cells[@cpu_shot].fired_upon?
      @cpu_shot = target_area.sample
    end
    @cpu_shot
  end


  def activate_target_mode
    @target_mode = true
    @hot_spot = @cpu_shot
  end

  def deactivate_target_mode
    @target_mode = false
    @hot_spot = nil
  end

  def save_state
    cpu_state = {
      :state => @target_mode,
      :target => @hot_spot
    }
  end

  def targeted_area(board)
    nearby_coordinates = [
      @hot_spot[0]+(@hot_spot[1].to_i - 1).to_s,
      @hot_spot[0]+(@hot_spot[1].to_i - 2).to_s,
      @hot_spot[0]+(@hot_spot[1].to_i + 1).to_s,
      @hot_spot[0]+(@hot_spot[1].to_i + 2).to_s,
      (@hot_spot[0].ord - 1).chr+@hot_spot[1],
      (@hot_spot[0].ord - 2).chr+@hot_spot[1],
      (@hot_spot[0].ord + 1).chr+@hot_spot[1],
      (@hot_spot[0].ord + 2).chr+@hot_spot[1]
    ]
    nearby_coordinates.find_all do |coordinate|
      board.valid_coordinate?(coordinate)
    end
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
    if @target_mode == true
      puts "Targeting systems online."
    end
  end
end
