require_relative '../../lib/bullet'

describe Bullet do
  describe '#char_map' do
    it 'is just a hyphen character in center position' do

      expect(Bullet.new(double, 0, 0).char_map).to eq( { [0,0] => '-' })
    end
  end

  describe '#update' do
    it 'moves the bullet one character to the right' do
      b = Bullet.new(double, 0, 0)

      b.update
      expect(b.anchor_x).to eq(1)
      expect(b.anchor_y).to eq(0)
    end

    it 'moves the bullet according to the speed parameter' do
      b = Bullet.new(double, 0, 0, speed: 3)

      b.update
      expect(b.anchor_x).to eq(3)
      expect(b.anchor_y).to eq(0)
    end
  end
end
