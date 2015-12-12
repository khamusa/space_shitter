require_relative '../../lib/world_objects/bullet'

describe Bullet do
  describe '#char_map' do
    it 'is just a hyphen character in center position' do

      expect(Bullet.new(double, 0, 0).char_map).to eq( { [0,0] => '-' })
    end
  end

  describe '#update' do
    it 'moves the bullet one character to the right' do
      b = Bullet.new(double, 0, 0, hor_speed: 1)

      b.update(1)
      expect(b.anchor_x).to eq(1)
      expect(b.anchor_y).to eq(0)
    end

    it 'moves the bullet according to the speed parameter' do
      b = Bullet.new(double, 0, 0, hor_speed: 3)

      b.update(1)
      expect(b.anchor_x).to eq(3)
      expect(b.anchor_y).to eq(0)
    end

    it 'moves the bullet proportionally to the amount of time passed' do
      b = Bullet.new(double, 0, 0, hor_speed: 3)

      b.update(0.5)
      expect(b.anchor_x).to eq(1.5)

      b.update(0.1)
      expect(b.anchor_x).to eq(1.8)
    end
  end

  describe '#collided_with?' do
    it 'does not collide with other bullets' do
      expect(Bullet.new(double, 0, 0)).
        not_to be_collided_with(Bullet.new(double, 0, 0))
    end
  end
end
