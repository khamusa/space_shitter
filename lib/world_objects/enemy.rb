require_relative '../world_object'

class Enemy
  include WorldObject

  def initialize(anchor_x, anchor_y, char_map = nil, options = {})
    self.char_map = char_map || {
      [-1,-1] => "XXX",
      [-1, 0] => "XOX",
      [-1, 1] => "XXX"
    }

    @hor_speed = options.fetch(:hor_speed, -10)

    self.anchor_x     = anchor_x
    self.anchor_y     = anchor_y
  end

  def update(delta_t)
    move( @hor_speed*delta_t, 0 )
  end
end
