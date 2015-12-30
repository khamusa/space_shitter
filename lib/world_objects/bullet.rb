require 'world_object'
require 'world_objects/movement/horizontal'

class Bullet
  include WorldObject
  include WorldObjects::Movement::Horizontal

  attr_reader :fired_by, :speed

  def initialize(anchor_x, anchor_y, opts = {})
    @fired_by      = opts.fetch(:fired_by)
    self.hor_speed = opts.fetch(:hor_speed, 30)
    self.char_map  = { [0, 0] => '-' }
    self.anchor_x  = anchor_x
    self.anchor_y  = anchor_y
  end

  def collided_with?(other_object)
    super &&
    other_object != fired_by &&
    !other_object.kind_of?(self.class)
  end

end
