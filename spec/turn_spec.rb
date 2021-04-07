require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/turn'

RSpec.describe Turn do
  describe "#initialize" do
    cpu_board = Board.new
    player_board = Board.new
    runtime_log = [ { :state => nil, :target => nil } ]
    turn = Turn.new(cpu_board, player_board, runtime_log.last)

    it "exists" do
      expect(turn).to be_instance_of(Turn)
    end
  end

  describe "#display_boards" do
    cpu_board = Board.new
    player_board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    runtime_log = [ { :state => nil, :target => nil } ]
    turn = Turn.new(cpu_board, player_board, runtime_log.last)

    it "prints a board that shows 'S' for player boards" do
      player_board.place(cruiser, ["A1", "A2", "A3"])
      expect{turn.display_boards}.to output("=============COMPUTER BOARD=============\n  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n==============PLAYER BOARD==============\n  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n").to_stdout
    end
  end

  # NO TEST for #player_shoots since it uses user input

  describe "#cpu_firing_procedure and #cpu_shot_validation" do
    cpu_board = Board.new
    player_board = Board.new
    runtime_log = [ { :state => nil, :target => nil } ]
    turn = Turn.new(cpu_board, player_board, runtime_log.last)

    # it "#generate_computer_shot returns valid cell on the board" do
    #   shot = turn.generate_computer_shot
    #   expect(player_board.cells[shot]).to be_instance_of(Cell)
    # end
    #
    # it "#computer_shoots fires upon a given cell" do
    #   shot = turn.generate_computer_shot
    #   turn.computer_shoots(shot)
    #
    #   expect(player_board.cells[shot].fired_upon?).to eq(true)
    # end

    it "fires upon a cell each time it's called, without repeating shots" do
      16.times do
        turn.cpu_firing_procedure
      end
      expected = player_board.cells.all? do |key, value|
        value.fired_upon? == true
      end

      expect(expected).to eq(true)
    end
  end

  describe "helper methods for #cpu_firing_procedure" do
    cpu_board = Board.new
    player_board = Board.new
    runtime_log = [ { :state => nil, :target => nil } ]
    turn = Turn.new(cpu_board, player_board, runtime_log.last)

    it '#activate_target_mode' do
      expect(turn.target_mode).to eq(nil)
      turn.activate_target_mode
      expect(turn.target_mode).to eq(true)
    end

    it '#deactivate_target_mode' do
      turn.deactivate_target_mode
      expect(turn.target_mode).to eq(false)
    end

    it '#save_state' do
      expect(turn.save_state[:state]).to eq(false)
      expect(turn.save_state[:target]).to eq(nil)
    end

    xit '#targeted_area' do
      targeted_area = turn.targeted_area(player_board)
      turn.hot_spot = "B2"
      expect(targeted_area).to be_instance_of(Array)
      expect(targeted_area.sort).to eq(["B1", "A2", "B3", "B4", "C2", "D2"].sort)
    end

  end

  describe "#display_results" do
    cpu_board = Board.new
    player_board = Board.new
    runtime_log = [ { :state => nil, :target => nil } ]
    turn = Turn.new(cpu_board, player_board, runtime_log.last)

    it "prints turn results accurately for player and computer" do
      turn.player_shot = "A1"
      cpu_board.cells[turn.player_shot].fire_upon
      turn.cpu_shot = "D1"
      player_board.cells[turn.cpu_shot].fire_upon
      expect{turn.display_results}.to output("Your shot on A1 was a miss.\nMy shot on D1 was a miss.\n").to_stdout
    end

  end
end
