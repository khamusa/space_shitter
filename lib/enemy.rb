require_relative 'world_object'

class Enemy
  include WorldObject

  def initialize(anchor_x, anchor_y, char_map = nil, options = {})
    self.char_map = char_map || {
      [-1,-1] => "XXX",
      [-1, 0] => "XOX",
      [-1, 1] => "XXX"
    }

    @hor_speed = options.fetch(:hor_speed, 0.25)
    @ver_speed = options.fetch(:ver_speed, 2)
    @amplitude = options.fetch(:amplitude, 4)

    # Note: there's a bug on collisions for which if the last line is
    # [-1,-1] => "XXX", collisions work
    # but if last line is [-1, 1] (which actually draws the enemy correctly)
    # the bullets won't hit the enemy...
    self.anchor_x     = anchor_x
    self.anchor_y     = anchor_y
    @center_y         = anchor_y
  end

  # Move to the left
  def update(current_tick)
    self.anchor_x -= @hor_speed
    self.anchor_y = (
      @center_y +
      Math.sin( current_tick * (@ver_speed / 100.0) ) * @amplitude
    ).round
  end
end
