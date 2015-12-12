require_relative '../../lib/world_objects/enemy.rb'

describe Enemy do
  it 'can be created with an initial positioning' do
    e = Enemy.new(10, 20)

    expect(e.anchor_x).to eq(10)
    expect(e.anchor_y).to eq(20)
  end

  it 'has a char map' do
    char_map = double
    e = Enemy.new(10, 20, char_map)

    expect(e.char_map).to eq char_map
  end

  describe '#update' do
    it 'moves the enemy to the left' do
      e = Enemy.new(10, 20)

      e.update(1)

      expect(e.anchor_x).to eq(9.75)
      expect(e.anchor_y).to eq(20)
    end

    it 'moves the enemy at a speed specified in the initializing parameters' do
      e = Enemy.new(10, 20, nil, hor_speed: -0.5)

      e.update(1)
      expect(e.anchor_x).to eq(9.5)

      e.update(2)
      expect(e.anchor_x).to eq(9)
    end
  end
end
