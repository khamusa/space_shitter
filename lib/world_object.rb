
BoundingBox = Struct.new(:min_x, :min_y, :max_x, :max_y)
module WorldObject

  def self.included(base)
    base.class_eval do
      attr_accessor :char_map, :anchor_x, :anchor_y
    end

    def move(offset_x, offset_y)
      self.anchor_x = anchor_x + offset_x
      self.anchor_y = anchor_y + offset_y
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
        max_x = [max_x + chars.length - 1, x].max

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
        bounding_box.max_y + anchor_y,
      )
    end

    def collided_with?(other_object)
      # Very rudimentary, bounding box comparison only
      other_object != self &&
      bbox_overlaps?(other_object.positioned_bounding_box)
    end

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
end
