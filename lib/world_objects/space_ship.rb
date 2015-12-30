require_relative 'bullet'
require_relative '../world_object'

class SpaceShip
  include WorldObject

  def fire!
    [ Bullet.new(anchor_x, anchor_y, fired_by: self) ]
  end
end
