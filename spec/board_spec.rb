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

end
