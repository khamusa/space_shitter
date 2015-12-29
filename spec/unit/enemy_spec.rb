require_relative '../../lib/world_objects/enemy.rb'

describe Enemy do
  it 'can be created with an initial positioning' do
    e = Enemy.new(10, 20)

    expect(e.anchor_x).to eq(10)
    expect(e.anchor_y).to eq(20)
  end

  it 'has a char map' do
    char_map = double
    e = Enemy.new(10, 20, char_map: char_map)

    expect(e.char_map).to eq char_map
  end

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
      e = Enemy.new(10, 20, hor_speed: -0.5)

      e.update(1)
      expect(e.anchor_x).to eq(9.5)

      e.update(1)
      expect(e.anchor_x).to eq(9)
    end

    it 'moves the enemy proportionally to the amount of time passed' do
      e = Enemy.new(10, 20, hor_speed: -0.5)

      e.update(0.5)
      expect(e.anchor_x).to eq(9.75)

      e.update(0.1)
      expect(e.anchor_x).to eq(9.7)
    end
  end
end
