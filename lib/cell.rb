class Cell
  attr_reader :coordinate, :ship

  def initialize(cell_coordinates)
    @coordinate = cell_coordinates
    @ship = nil
    @fired_upon = false # REFACTOR: make fired_upon? instance var
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  # REFACTOR: Can be swept under fired_upon? instance var
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
