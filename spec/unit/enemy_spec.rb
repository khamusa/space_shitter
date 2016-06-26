require 'spec_helper'
require_relative '../../lib/world_objects/enemy.rb'

describe Enemy do
  it 'has a horizontal speed' do
    expect { Enemy.new(10, 20).hor_speed }.not_to raise_error
  end

  describe '#update' do
    it 'moves the enemy' do
      e = Enemy.new(10, 20, hor_speed: -1)

      e.update(1)

      expect(e.anchor_x).to eq(9)
      expect(e.anchor_y).to eq(20)
    end

    it 'moves the enemy at a speed specified in the initializing parameters' do
      e = Enemy.new(10, 20, hor_speed: -0.4)

      e.update(1)
      expect(e.anchor_x).to eq(10)

      e.update(1)
      expect(e.anchor_x).to eq(9)
    end

    it 'moves the enemy proportionally to the amount of time passed' do
      e = Enemy.new(10, 20, hor_speed: -0.5)

      e.update(0.5)
      expect(e.anchor_x).to eq(10)

      e.update(0.5)
      expect(e.anchor_x).to eq(10)

      e.update(0.5)
      expect(e.anchor_x).to eq(9)

      e.update(0.5)
      expect(e.anchor_x).to eq(9)
    end
  end
end
