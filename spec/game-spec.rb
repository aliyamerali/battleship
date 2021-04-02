require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'

describe Game do

  describe '#initialize' do

  end

  describe '#welcome_message' do
    it 'prints welcome message' do

    end

    xit 'takes command line input of p or q' do
    end
  end

  describe '#random_coordinate_generator' do
    game = Game.new

    it 'randomly selects horizontal or vertical' do
      expect(game.random_coordinate_generator).to be_between(0, 1)
    end
  end
end
