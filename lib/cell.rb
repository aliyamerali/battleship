class Cell
  attr_reader :coordinate, :ship

  def initialize(cell_coordinates)
    @coordinate = cell_coordinates
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @fired_upon = true
    if @ship != nil
      @ship.hit
    end
  end

end
