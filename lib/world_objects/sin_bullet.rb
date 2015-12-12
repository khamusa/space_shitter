require_relative 'bullet'

class SinBullet < Bullet

  def initialize(fired_by, anchor_x, anchor_y, opts = {})
    @center_y = anchor_y

    @ver_speed = opts.fetch(:ver_speed, 2)
    @amplitude = opts.fetch(:amplitude, 4)

    super
  end

  def update(current_tick)
    move(speed, 0)
    self.anchor_y = (
      @center_y +
      Math.sin( current_tick * (@ver_speed / 100.0) ) * @amplitude
    ).round
  end

end
