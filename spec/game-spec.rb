require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/game'
require './lib/turn'

RSpec.describe Game do

  describe '#initialize and #generate_ships_hash' do
    game = Game.new
    cpu_cruiser = game.ships[:cpu][:cruiser]
    player_sub = game.ships[:player][:submarine]

    it 'creates cpu and player boards' do
      expect(game.cpu_board).to be_instance_of(Board)
      expect(game.player_board).to be_instance_of(Board)
    end

    it 'can access ships through hash' do
      expect(cpu_cruiser.health).to eq(3)
      expect(player_sub.health).to eq(2)
    end
  end

  # Skipped tests for:
    # #get_board_dimensions
    # #player_board_setup
    # #get_player_coordinates
  # due to requiring input


  # INSERT #cpu_board_setup tests here
  ################


  describe '#merali_algorithm' do
    game = Game.new
    cpu_board = Board.new
    cpu_cruiser = game.ships[:cpu][:cruiser]
    cpu_sub = game.ships[:cpu][:submarine]


    it 'returns an array of coordinates equal to ship length' do
      expect(game.merali_algorithm(cpu_board, cpu_cruiser)).to be_instance_of(Array)
      expect(game.merali_algorithm(cpu_board, cpu_cruiser).count).to eq(3)
      expect(game.merali_algorithm(cpu_board, cpu_sub).count).to eq(2)
    end

    it 'never returns a coordinate that has a ship on it' do
      coord1 = "A1"
      coord2 = "A2"
      coord3 = "A3"
      test_placement = [coord1, coord2, coord3]
      cpu_board.place(cpu_cruiser, test_placement)
      runtime_results = []

      # Run algorithm 100 times and store each coordinate set into runtime_results
      100.times do
        runtime_results << game.merali_algorithm(cpu_board, cpu_sub)
      end

      # If any results in runtime include preexisting coordinates, then returns true
      failed_runs = runtime_results.any? do |coordinates|
        coordinates.include?(coord1)
        coordinates.include?(coord2)
        coordinates.include?(coord3)
      end
      expect(failed_runs).to eq(false)
    end
  end


  # INSERT #sample_possible_coordinates TESTS HERE
  ###########
  # 
  # describe "#generate_possible_coordinates and #sample_possible_coordinates" do
  #   it '#generate_possible_coordinates returns an array of 4 possible coordinate arrays' do
  #     # game = Game.new
  #     mock_game = double("game")
  #     board = Board.new
  #     ship = Ship.new("cruiser", 3)
  #     anchor = board.cells.keys.sample
  #     possible_coordinates = mock_game.generate_possible_coordinates(ship, anchor)
  #
  #     expect(possible_coordinates).to be_instance_of(Array)
  #     expect(possible_coordinates.length).to eq(4)
  #     # expect(game.sample_possible_coordinates(cpu_board, starting_array, 1)).to be_instance_of(Array)
  #   end
  # end


  describe '#griffith_algorithm' do
    game = Game.new
    cpu_cruiser = game.ships[:cpu][:cruiser]
    cpu_sub = game.ships[:cpu][:submarine]

    it 'returns an array of coordinates equal to ship length' do
      expect(game.griffith_algorithm(game.cpu_board, cpu_cruiser)).to be_instance_of(Array)
      expect(game.griffith_algorithm(game.cpu_board, cpu_cruiser).count).to eq(3)
      expect(game.griffith_algorithm(game.cpu_board, cpu_sub).count).to eq(2)
    end

    it 'never returns a coordinate that has a ship on it' do
      coord1 = "A1"
      coord2 = "A2"
      coord3 = "A3"
      test_placement = [coord1, coord2, coord3]
      game.cpu_board.place(cpu_cruiser, test_placement)
      runtime_results = []

      # Run algorithm 100 times and store each coordinate set into runtime_results
      100.times do
        runtime_results << game.griffith_algorithm(game.cpu_board, cpu_sub)
      end

      # If any results in runtime include preexisting coordinates, then returns true
      failed_runs = runtime_results.any? do |coordinates|
        coordinates.include?(coord1)
        coordinates.include?(coord2)
        coordinates.include?(coord3)
      end
      expect(failed_runs).to eq(false)
    end
  end

  describe '#create_coordinate_array' do
    game = Game.new
    cpu_cruiser = game.ships[:cpu][:cruiser]

    it 'returns an array of arrays' do
      expect(game.create_coordinate_array(game.cpu_board, cpu_cruiser)[0]).to be_instance_of(Array)
    end

    it 'nested arrays contain equal elements to ship length' do
      expect(game.create_coordinate_array(game.cpu_board, cpu_cruiser)[0].count).to eq(3)
    end

  end

  describe '#play and #end_game' do
    game = Game.new
    game2 = Game.new
    cpu_cruiser = game.ships[:cpu][:cruiser]
    cpu_sub = game.ships[:cpu][:submarine]

    it 'outputs end_game info when cpu ship sunk' do
      3.times do
        cpu_cruiser.hit
      end
      2.times do
        cpu_sub.hit
      end

      expect{game.play}.to output("You won!\n").to_stdout
    end

    it 'returns correct return value' do
      3.times do
        game2.ships[:player][:cruiser].hit
      end
      2.times do
        game2.ships[:player][:submarine].hit
      end

      expect(game2.end_game).to eq("I won!")
    end
  end

  describe "#cpu_game_over and #player_game_over" do
    game = Game.new
    game2 = Game.new
    cpu_cruiser = game.ships[:cpu][:cruiser]
    cpu_sub = game.ships[:cpu][:submarine]

    it 'returns correct booleans if cpu loses' do
      #require 'pry'; binding.pry

      3.times do
        cpu_cruiser.hit
      end
      2.times do
        cpu_sub.hit
      end
      expect(game.cpu_game_over?).to eq(true)
      expect(game.player_game_over?).to eq(false)
    end

    it 'returns correct booleans if player loses' do
      3.times do
        game2.ships[:player][:cruiser].hit
      end
      2.times do
        game2.ships[:player][:submarine].hit
      end
      expect(game2.cpu_game_over?).to eq(false)
      expect(game2.player_game_over?).to eq(true)
    end

  end

end
