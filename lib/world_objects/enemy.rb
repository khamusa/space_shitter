require 'world_object'
require 'world_objects/movement/horizontal'

class Enemy
  include WorldObject
  include WorldObjects::Movement::Horizontal

  def initialize(anchor_x, anchor_y, options = {})
    self.char_map = options[:char_map] || {
      [-1,-1] => "XXX",
      [-1, 0] => "XOX",
      [-1, 1] => "XXX"''
    }

    self.hor_speed    = options.fetch(:hor_speed, -10)
    self.anchor_x     = anchor_x
    self.anchor_y     = anchor_y
  end

end
