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

  # Render has a default value of false, and passing in 'true' will
  # show placement of ship.
  def render(value = false)
    # Added the "S" case first since it's more stringent than the "." case
    if value == true && empty? == false
      "S"
    elsif fired_upon? == false
      "."
    elsif fired_upon? && empty?
      "M"
    elsif fired_upon? && empty? == false && ship.sunk? == false
      "H"
    elsif fired_upon? && ship.sunk?
      "X"
    end
  end

end
