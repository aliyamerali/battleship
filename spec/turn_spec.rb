require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/turn'

RSpec.describe Turn do
  describe "#initialize" do
    cpu_board = Board.new
    player_board = Board.new
    turn = Turn.new(cpu_board, player_board)

    it "exists" do
      expect(turn).to be_instance_of(Turn)
    end
  end

  describe "#display_boards" do
    cpu_board = Board.new
    player_board = Board.new
    turn = Turn.new(cpu_board, player_board)
    cruiser = Ship.new("Cruiser", 3)

    it "prints a board that shows 'S' for player boards" do
      player_board.place(cruiser, ["A1", "A2", "A3"])
      expect{turn.display_boards}.to output("=============COMPUTER BOARD=============\n  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n==============PLAYER BOARD==============\n  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n").to_stdout
    end
  end

  # NO TEST for #player_shoots since it uses user input

  xdescribe "#generate_computer_shot and #computer_shoots" do
    cpu_board = Board.new
    player_board = Board.new
    turn = Turn.new(cpu_board, player_board)

    it "#generate_computer_shot returns valid cell on the board" do
      shot = turn.generate_computer_shot
      expect(player_board.cells[shot]).to be_instance_of(Cell)
    end

    it "#computer_shoots fires upon a given cell" do
      shot = turn.generate_computer_shot
      turn.computer_shoots(shot)

      expect(player_board.cells[shot].fired_upon?).to eq(true)
    end

    it "#generate_computer_shot does not return a cell that has been fired upon" do
      15.times do
        shot = turn.generate_computer_shot
        turn.computer_shoots(shot)
      end
      expected = player_board.cells.all? do |key, value|
        value.fired_upon? == true
      end

      expect(expected).to eq(true)
    end
  end

  describe "#display_results" do
    cpu_board = Board.new
    player_board = Board.new
    turn = Turn.new(cpu_board, player_board)
    turn.player_shot = "A1"
    cpu_board.cells[turn.player_shot].fire_upon
    turn.cpu_shot = "D1"
    player_board.cells[turn.cpu_shot].fire_upon

    it "prints turn results accurately for player and computer" do
      expect{turn.display_results}.to output("Your shot on A1 was a miss.\nMy shot on D1 was a miss.\n").to_stdout
    end

  end
end
