require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'

RSpec.describe Game do

  describe '#initialize' do

  end

  describe '#welcome_message' do
    it 'prints welcome message' do
      expect{game.welcome_message}.to output("Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.").to_stdout
    end

    xit 'takes command line input of p or q' do
    end
  end

  describe '#random_coordinate_generator' do
    game = Game.new

    xit 'randomly selects horizontal or vertical' do
      expect(game.random_coordinate_generator).to be_between(0, 1)
    end
  end

  describe "#generate_random_coordinates" do
    game = Game.new
    cpu_board = Board.new
    ship = Ship.new("cruiser", 3)
    starting_array = game.create_coordinate_array(cpu_board, ship)

    it 'returns array' do
      expect(game.generate_random_coordinates(cpu_board, starting_array, 1)).to be_instance_of(Array)
    end
  end
end
