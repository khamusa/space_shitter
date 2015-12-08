require_relative 'world_object'

class Enemy
  include WorldObject

  def initialize(anchor_x, anchor_y, char_map = nil)
    self.char_map = char_map || {
      [-1,-1] => "XXX",
      [-1, 0] => "XOX",
      [-1, 1] => "XXX"
    }

    # Note: there's a bug on collisions for which if the last line is
    # [-1,-1] => "XXX", collisions work
    # but if last line is [-1, 1] (which actually draws the enemy correctly)
    # the bullets won't hit the enemy...
    @anchor_x     = anchor_x
    @anchor_y     = anchor_y
  end

  # Move to the left
  def update(current_tick)
    self.anchor_x -= 0.3
  end
end
