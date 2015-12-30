
BoundingBox = Struct.new(:min_x, :min_y, :max_x, :max_y)
module WorldObject

  def self.included(base)
    base.class_eval do
      attr_accessor :char_map
      attr_writer :anchor_x, :anchor_y
    end
  end

  def anchor_x
    @anchor_x.round
  end

  def anchor_y
    @anchor_y.round
  end

  def initialize(anchor_x, anchor_y, options = {})
    @anchor_x = anchor_x
    @anchor_y = anchor_y
    self.char_map = options.fetch(:char_map, {[0,0] => "X"})
  end

  def update(delta_t)
    # noop
  end

  def move(offset_x, offset_y)
    # We avoid using the accessors as we do not want
    # the anchors to be rounded to closest integer
    @anchor_x = @anchor_x + offset_x
    @anchor_y = @anchor_y + offset_y
  end

  def char_map
    @char_map
  end

  def destroy!
    @destroyed = true
  end

  def destroyed?
    @destroyed
  end

  def bounding_box
    return @bounding_box if @bounding_box

    min_y = min_x = Float::INFINITY
    max_y = max_x = min_x * -1

    char_map.each do |(x, y), chars|
      max_y = [max_y, y].max
      max_x = [x + chars.length - 1, max_x].max

      min_y = [min_y, y].min
      min_x = [min_x, x].min
    end
    @bounding_box = BoundingBox.new min_x, min_y, max_x, max_y
  end

  def positioned_bounding_box
    BoundingBox.new(
      bounding_box.min_x + anchor_x,
      bounding_box.min_y + anchor_y,
      bounding_box.max_x + anchor_x,
      bounding_box.max_y + anchor_y
    )
  end

  def collided_with?(other_object)
    # Very rudimentary, bounding box comparison only
    other_object != self &&
    bbox_overlaps?(other_object.positioned_bounding_box)
  end

  # By default whenever an object leaves the viewport
  # it will be destroyed. Classes including this module
  # may decide otherwise by overriding this method.,
  def obj_left_viewport!(direction)
    destroy!
  end

  private

  def bbox_overlaps?(other_bbox)
    my_bbox = positioned_bounding_box

    # They overlap if they not(do not overlap)
    !(
      my_bbox.min_x > other_bbox.max_x ||
      my_bbox.min_y > other_bbox.max_y ||
      my_bbox.max_x < other_bbox.min_x ||
      my_bbox.max_y < other_bbox.min_y
    )
  end
end
