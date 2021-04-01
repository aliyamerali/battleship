require './lib/cell'
require './lib/ship'
require './lib/board'

RSpec.describe Board do
  describe "#initialize" do
    board = Board.new

    it 'is an instance of Board' do
      expect(board).to be_instance_of(Board)
    end

    it '@cells is a hash and is composed of 16 pairs' do
      expect(board.cells).to be_instance_of(Hash)
      expect(board.cells.length).to eq(16)
    end

    it 'can access cell objects in @cells hash' do
      expect(board.cells["A1"]).to be_instance_of(Cell)
    end

  end

  describe "#valid_coordinate?" do
    board = Board.new

    it 'returns true for a coordinate in the cells hash' do
      expect(board.valid_coordinate?("A1")).to eq(true)
    end

    it 'returns true for a coordinate in the cells hash' do
      expect(board.valid_coordinate?("Z1")).to eq(false)
    end
  end

  describe "#valid_placement?" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it 'validates that number of coordinates = length of the ship' do
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
    end

    it 'validates that number of coordinates = length of the ship' do
      expect(board.valid_placement?(cruiser, ["A3"])).to eq(false)
    end

    it 'validates that coordinates are consecutive either in rows or cols' do
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(board.valid_placement?(cruiser, ["A1", "B1", "C1"])).to eq(true)
      expect(board.valid_placement?(cruiser, ["A3", "A2", "A1"])).to eq(false)
      expect(board.valid_placement?(cruiser, ["C4", "C3", "C1"])).to eq(false)
      expect(board.valid_placement?(submarine, ["D1", "D2"])).to eq(true)
      expect(board.valid_placement?(submarine, ["D2", "D1"])).to eq(false)
    end
  end

  describe "#check_consecutive" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it 'returns true for consecutive letters on board' do
      expect(board.check_consecutive(cruiser, [1, 2, 3])).to eq(true)
    end
  end

  describe "#check_static" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it 'returns true if columns do not change' do
      expect(board.check_static([2, 2, 2])).to eq(true)
    end

    it 'returns false if rows change' do
      expect(board.check_static(["A", "B", "C"])).to eq(false)
    end
  end

  describe "#place" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    # Reminder that cells is a hash, and we're querying keys
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
      board.place(cruiser, ["B2", "C2"])
      expect(cell_4.ship).to be_instance_of(Ship)
      expect(cell_5.ship.name).to eq("Submarine")
    end

  end


end
