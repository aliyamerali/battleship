require './lib/ship'

RSpec.describe Ship do
  describe "#initialize" do
    ship = Ship.new("Cruiser", 3)

    it "exists" do
      expect(ship).to be_instance_of(Ship)
    end

  end

end
