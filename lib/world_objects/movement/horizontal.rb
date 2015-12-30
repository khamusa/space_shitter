module WorldObjects; module Movement

  module Horizontal

    def self.included(base)
      base.class_eval do
        attr_accessor :hor_speed
      end
    end

    def initialize(anchor_x, anchor_y, options = {})
      super
      self.hor_speed = options.fetch(:hor_speed, 1)
    end

    def update(delta_t)
      move( delta_t * hor_speed, 0 )
    end
  end

end; end
