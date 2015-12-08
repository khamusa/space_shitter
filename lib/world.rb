class World

  attr_reader :width, :height, :current_tick
  attr_accessor :objects

  def initialize(width, height)
    @width        = width
    @height       = height
    @objects      = []

    @current_tick = 0
  end

  def register_objects(new_objects)
    objects.concat(new_objects)
  end

  def game_tick
    objects.each { |o| o.update(current_tick) }
    garbage_collect!
  end

  def garbage_collect!
    self.objects = objects.select do |obj|
      collisions = find_collisions?(obj)

      unless collisions.empty?
        obj.destroy!
        collisions.each(&:destroy!)
      end

      obj.destroy! if obj_left_viewport?(obj)

      !obj.destroyed?
    end
  end

  private

  def find_collisions?(an_obj)
    objects.select do |another|
      an_obj.collided_with?(another) &&
      another.collided_with?(an_obj)
    end
  end

  def obj_left_viewport?(obj)
    bbox = obj.positioned_bounding_box

    bbox.min_x <= 0     ||
    bbox.max_x > width  ||

    bbox.min_y <= 0     ||
    bbox.max_y > height
  end
end
