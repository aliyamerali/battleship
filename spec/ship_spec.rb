require './lib/ship'

RSpec.describe Ship do
  describe "#initialize" do
    ship = Ship.new("Cruiser", 3)

    it "exists" do
      expect(ship).to be_instance_of(Ship)
    end

    it 'has accessible attributes' do
      expect(ship.name).to eq("Cruiser")
      expect(ship.length).to eq(3)
      expect(ship.health).to eq(3)
    end
  end

  describe "#sunk?" do
    ship = Ship.new("Cruiser", 3)

    it 'returns false when health is greater than zero' do
      expect(ship.sunk?).to eq(false)
    end

    it 'returns true when health is zero' do
      3.times { ship.hit }
      expect(ship.sunk?).to eq(true)
    end

  end

  describe "#hit" do
    ship = Ship.new("Cruiser", 3)

    it 'reduces health by one' do
      ship.hit
      expect(ship.health).to eq(2)
    end

  end

end
