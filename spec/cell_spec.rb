require './lib/cell'
require './lib/ship'

RSpec.describe Cell do

  describe "#initialize" do
    cell = Cell.new("A3")

    it "exists" do
      expect(cell).to be_instance_of(Cell)
    end

    it "returns coordinate attribute" do
      expect(cell.coordinate).to eq("A3")
    end
  end

  describe "#empty?" do
    cell = Cell.new("A3")

    it "returns true for empty upon creation" do
      expect(cell.empty?).to eq(true)
    end
  end

  describe "#place_ship" do
    cell = Cell.new("A3")
    ship = Ship.new("Cruiser", 3)

    it "updates cell.ship state to be an instance of ship" do
      cell.place_ship(ship)
      expect(cell.ship).to be_instance_of(Ship)
    end
  end

  # These two methods work closely enough together to bundle them in the tests
  describe "#fired_upon? and #fire_upon" do
    cell1 = Cell.new("A3")
    cell2 = Cell.new("B1")
    ship = Ship.new("Cruiser", 3)

    it "fired_upon? returns correct boolean" do
      cell1.fire_upon
      expect(cell1.fired_upon?).to eq(true)
      expect(cell2.fired_upon?).to eq(false) # didn't call fire_upon on cell2, so expect false
    end

    # I would think an if/then statement in fire_upon would invoke #hit if ship is on cell
    it "fire_upon reduces ship health" do
      cell2.place_ship(ship)
      cell2.fire_upon
      expect(ship.health).to eq(2)
    end
  end

  describe "#render" do
    cell1 = Cell.new("A3")
    cell2 = Cell.new("B1")
    ship = Ship.new("Cruiser", 3)

    it "returns \`.`` if a cell has not been fired on" do
      expect(cell1.render).to eq(".")
    end

    it "returns \`M` if a cell has been fired on and does not contain a ship" do
      cell1.fire_upon

      expect(cell1.render).to eq("M")
    end

    it "returns \'H' if a cell has been fired on and it contains a ship" do
      cell1.place_ship(ship)
      cell1.fire_upon

      expect(cell1.render).to eq("H")
    end

    # This test still needs to pass
    it "returns \`X` if a cell has been fired on and its ship has been sunk" do
      cell1.place_ship(ship)
      cell1.fire_upon
      ship.hit #Shortcut to reduce ship health manually to test sunk #render behavior
      ship.hit

      expect(cell1.render).to eq("X")
    end


  end

end
