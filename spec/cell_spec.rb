require './lib/cell'
require './lib/ship'

RSpec.describe Cell do

  describe "#initialize" do
    cell = Cell.new("A3")

    it "exists" do
      expect(cell).to be_instance_of(Cell)
    end
  end


end
