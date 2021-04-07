require './lib/cell'
require './lib/ship'
require './lib/board'

RSpec.describe Board do
  describe "#initialize" do
    board = Board.new(5)

    it 'is an instance of Board' do
      expect(board).to be_instance_of(Board)
    end

    it 'can access cell objects in @cells hash' do
      expect(board.cells["A1"]).to be_instance_of(Cell)
    end

    it 'creates a hash of cells on the board based on input dimension' do
      expect(board.cells.length).to eq(25)
    end

    it 'has a default dimension of 4x4' do
      board2 = Board.new
      expect(board2.cells.length).to eq(16)
    end
  end

  describe "#generate_coordinates and generate_board_hash" do
    board = Board.new

    it 'creates an array of full coordinates from rows and columns' do
      expect(board.generate_coordinates[0]).to eq("A1")
    end

    it 'returns @cells hash and is composed of 16 pairs' do
      expect(board.cells).to be_instance_of(Hash)
      expect(board.cells.length).to eq(16)
    end
  end


  describe "#valid_coordinate?" do
    board = Board.new

    it 'returns true for a coordinate in the cells hash' do
      expect(board.valid_coordinate?("A1")).to eq(true)
    end

    it 'returns false for a coordinate outside the cells hash' do
      expect(board.valid_coordinate?("Z1")).to eq(false)
    end
  end

  describe "#valid_coordinates?" do
    board = Board.new

    it 'returns true for an array of coordinates in the cells hash' do
      expect(board.valid_coordinates?(["A1", "A2", "A3"])).to eq(true)
    end

    it 'returns false for an array of coordinates outside the cells hash' do
      expect(board.valid_coordinates?(["Z1", "G5", "B2"])).to eq(false)
    end
  end

  describe "#valid_placement?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it 'returns false when improper coordinates are provided' do
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(board.valid_placement?(cruiser, ["A1", "B1", "C1"])).to eq(true)
      expect(board.valid_placement?(cruiser, ["A3", "A2", "A1"])).to eq(false)
      expect(board.valid_placement?(cruiser, ["C4", "C3", "C2"])).to eq(false)
      expect(board.valid_placement?(submarine, ["D1", "D2"])).to eq(true)
      expect(board.valid_placement?(submarine, ["D2", "D1"])).to eq(false)
    end
  end

  describe "#player_input_valid?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    sub = Ship.new("Submarine", 2)

    it 'validates that number of coordinates = length of the ship' do
      expect(board.player_input_valid?(cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(board.player_input_valid?(cruiser, ["A3"])).to eq(false)
    end

    it 'returns true if coordinates valid and spaces open' do
      expect(board.player_input_valid?(cruiser, ["A1", "A2", "A3"])).to eq(true)
    end

    it 'returns false if spot occupied on board' do
      board.place(cruiser, ["A1", "B1", "C1"])
      expect(board.player_input_valid?(sub, ["B1", "B2"])).to eq(false)
    end
  end

  describe "#is_vertical? and #is_horizontal?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)

    it 'returns true if ship is horizontal' do
      expect(board.is_horizontal?(cruiser, ["A1", "A2", "A3"])).to eq(true)
    end

    it 'returns true is ship is vertical' do
      expect(board.is_vertical?(cruiser, ["B2", "C2", "D2"])).to eq(true)
    end
  end


  describe "#consecutive?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it 'returns true for consecutive numbers or letters on board' do
      expect(board.consecutive?(cruiser, [1, 2, 3])).to eq(true)
      expect(board.consecutive?(cruiser, ["A", "B", "C"])).to eq(true)
    end

    it 'returns false for non-consecutive numbers or letters on board' do
      expect(board.consecutive?(cruiser, [1, 2, 4])).to eq(false)
      expect(board.consecutive?(cruiser, ["A", "B", "D"])).to eq(false)
    end
  end

  describe "#matching_coordinate?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it 'returns true if columns or rows do not change' do
      expect(board.matching_coordinate?([2, 2, 2])).to eq(true)
      expect(board.matching_coordinate?(["C", "C", "C"])).to eq(true)
    end

    it 'returns false if rows or columns change' do
      expect(board.matching_coordinate?(["A", "B", "C"])).to eq(false)
      expect(board.matching_coordinate?([3, 4, 5])).to eq(false)
    end
  end

  describe "#overlap?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    coordinates1 = ["A1", "A2", "A3"]
    coordinates2 = ["A1", "A2", "A3"]

    it 'returns false if no overlap' do
      expect(board.overlap?(coordinates1)).to eq(false)
    end
    it 'returns true if there is overlap' do
      board.place(cruiser, coordinates1)
      expect(board.overlap?(coordinates2)).to eq(true)
    end
  end

  describe "#parse_rows and #parse_columns methods" do
    board = Board.new
    coordinates1 = ["A1", "A2", "A3"]
    coordinates2 = ["B1", "Q9", "L5"]

    it '#parse_rows returns an array of strings with row names' do
      expect(board.parse_rows(coordinates1)).to eq(["A", "A", "A"])
      expect(board.parse_rows(coordinates2)).to eq(["B", "Q", "L"])
    end

    it '#parse_columns returns an array of integers with column names' do
      expect(board.parse_columns(coordinates1)).to eq([1, 2, 3])
      expect(board.parse_columns(coordinates2)).to eq([1, 9, 5])
    end
  end

  describe "#place" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    cell_1 = board.cells["A1"]
    cell_2 = board.cells["A2"]
    cell_3 = board.cells["A3"]
    cell_4 = board.cells["B2"]
    cell_5 = board.cells["C2"]

    it 'can place a cruiser on open cells' do
      board.place(cruiser, ["A1", "A2", "A3"])
      expect(cell_1.ship).to be_instance_of(Ship)
      expect(cell_2.ship.name).to eq("Cruiser")
      expect(cell_3.ship.length).to eq(3)
    end

    it 'can place a submarine on open cells' do
      board.place(submarine, ["B2", "C2"])
      expect(cell_4.ship).to be_instance_of(Ship)
      expect(cell_5.ship.name).to eq("Submarine")
    end

    it 'does not place ships on invalid cells' do
      expect(board.place(submarine, ["C2", "D2"])).to eq(false)
    end
  end

  describe '#render' do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)

    it 'prints an empty board to the screen when called at game start' do
      expect{board.render}.to output("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n").to_stdout
      expect{board.render(true)}.to output("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n").to_stdout
    end

    it 'prints a board with hidden ships when passed value true' do
      board.place(cruiser, ["A1", "A2", "A3"])
      expect{board.render(true)}.to output("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n").to_stdout
    end

    it 'prints a board with misses marked' do
      board.cells["B1"].fire_upon
      expect{board.render}.to output("  1 2 3 4 \nA . . . . \nB M . . . \nC . . . . \nD . . . . \n").to_stdout
    end

    it 'prints a board with hits marked'do
      board.cells["A1"].fire_upon
      expect{board.render}.to output("  1 2 3 4 \nA H . . . \nB M . . . \nC . . . . \nD . . . . \n").to_stdout
    end

    it 'prints a board with sunk ships marked' do
      board.cells["A2"].fire_upon
      board.cells["A3"].fire_upon
      expect{board.render}.to output("  1 2 3 4 \nA X X X . \nB M . . . \nC . . . . \nD . . . . \n").to_stdout
    end
  end


end
