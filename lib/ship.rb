class Ship
attr_reader :name, :length, :health

  def initialize(ship_name, ship_length)
    @name = ship_name
    @length = ship_length
    @health = @length
  end

  def sunk?
    @health == 0
  end

  def hit
    @health -= 1
  end

end
