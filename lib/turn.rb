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
    @cpu_board.render
    puts "==============PLAYER BOARD=============="
    @player_board.render(true)
  end

  def get_user_shot
    # asks player for their shot
  end

  def get_computer_shot
    # generate a random shot, not fire on a space that has already been fired on.
  end

  def display_results

  end
end
