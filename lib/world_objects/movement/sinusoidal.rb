require 'world_objects/movement/horizontal'

module WorldObjects; module Movement

  module Sinusoidal

    def self.included(base)
      base.class_eval do
        attr_accessor :amplitude, :frequency
      end
    end

    def initialize(anchor_x, anchor_y, options = {})
      super
      self.amplitude = options.fetch(:amplitude, 1)
      self.frequency = options.fetch(:frequency, 1)
    end

    def update(delta_t)
      super

      @initial_y         ||= anchor_y
      @accumulated_delta ||= 0
      # By fetching the remainder we ensure the accumulated delta doesn't grow
      # inadvertendly
      @accumulated_delta   = (@accumulated_delta + delta_t) % (2*Math::PI)

      y_move = Math.sin(frequency * @accumulated_delta) * amplitude
      self.anchor_y = @initial_y + y_move
    end

  end

end; end
