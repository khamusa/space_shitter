class World

  attr_reader :width, :height
  attr_accessor :objects, :current_time

  def initialize(width, height, initial_objects = [])
    @width        = width
    @height       = height
    @objects      = initial_objects

    @current_time = Time.now
  end

  def register_objects(new_objects)
    objects.concat(new_objects)
  end

  def game_tick
    update_objects
    garbage_collect!
  end

  def garbage_collect!
    self.objects = objects.select do |obj|
      collisions = find_collisions?(obj)

      unless collisions.empty?
        obj.destroy!
        collisions.each(&:destroy!)
      end

      !obj.destroyed?
    end
  end

  private

  def update_objects
    now       = Time.now
    time_diff = now - current_time

    objects.each do |o|
      update_object(o, time_diff)

      test_object_leaving_viewport(o)
    end

    self.current_time = now
  end

  def test_object_leaving_viewport(o)
    leave_from = obj_left_viewport?(o)

    o.obj_left_viewport!(leave_from) if leave_from
  end

  def update_object(o, time_diff)
    o.update(time_diff)
  end

  def find_collisions?(an_obj)
    objects.select do |another|
      an_obj.collided_with?(another) &&
      another.collided_with?(an_obj)
    end
  end

  def obj_left_viewport?(obj)
    bbox = obj.positioned_bounding_box

    bbox.min_x < 0      && :left  ||
    bbox.max_x > width  && :right ||

    bbox.min_y < 0     && :top   ||
    bbox.max_y > height && :bottom
  end
end
