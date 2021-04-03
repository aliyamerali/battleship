require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/turn'

RSpec.describe Turn do

  describe "#generate_computer_shot and #computer_shoots" do
    cpu_board = Board.new
    player_board = Board.new
    turn = Turn.new(cpu_board, player_board)

    it '#generate_computer_shot returns valid cell on the board' do
      shot = turn.generate_computer_shot
      expect(player_board.cells[shot]).to be_instance_of(Cell)
    end

    it '#generate_computer_shot does not return a cell that has been fired upon' do
      shot = turn.generate_computer_shot
      expect(player_board.cells[shot].fired_upon?).to eq(false)
    end

    it '#computer_shoots fires upon a given cell' do
      shot = turn.generate_computer_shot
      turn.computer_shoots(shot)

      expect(player_board.cells[shot].fired_upon?).to eq(true)
    end
  end

end
