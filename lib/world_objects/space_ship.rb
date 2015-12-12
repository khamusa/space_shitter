require_relative 'bullet'
require_relative '../world_object'

class SpaceShip
  include WorldObject

  def initialize(anchor_x, anchor_y, char_map)
    self.char_map = char_map
    @anchor_x     = anchor_x
    @anchor_y     = anchor_y
  end

  def fire!
    [ Bullet.new(self, anchor_x, anchor_y) ]
  end

  def update(current_tick); true; end

end
