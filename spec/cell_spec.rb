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
end
