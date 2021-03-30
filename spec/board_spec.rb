require './lib/cell'
require './lib/ship'
require './lib/board'

RSpec.describe Board do
  describe "#initialize" do
    board = Board.new

    it 'is an instance of Board' do
      expect(board).to be_instance_of(Board)
    end

  end

end
