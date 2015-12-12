require_relative '../world_object'

class Bullet
  include WorldObject

  attr_reader :fired_by, :speed

  def initialize(fired_by, anchor_x, anchor_y, opts = {})
    @fired_by     = fired_by
    @speed        = opts.fetch(:hor_speed, 30)
    self.char_map = { [0, 0] => '-' }

    self.anchor_x = anchor_x
    self.anchor_y = anchor_y
  end

  def update(delta_t)
    move(delta_t * speed, 0)
  end

  def collided_with?(other_object)
    super &&
    other_object != fired_by &&
    !other_object.kind_of?(self.class)
  end

end
