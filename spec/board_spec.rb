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

    xit 'validates that number of coordinates = length of the ship' do
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
    end

    xit 'validates that number of coordinates = length of the ship' do
      expect(board.valid_placement?(cruiser, ["A3"])).to eq(false)
    end

    xit 'validates that coordinates are consecutive either in rows or cols' do
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eq(true)
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

end
