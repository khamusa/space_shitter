require_relative '../../lib/world_objects/space_ship'

describe SpaceShip do
  let(:spaceship) { SpaceShip.new 10, 20, char_map: { [0, 0] => 'Y' } }

  describe '#move' do
    it 'moves the spaceship by changing anchor_x and anchor_y' do
      spaceship.move(2, 3)

      expect(spaceship.anchor_x).to eq(12)
      expect(spaceship.anchor_y).to eq(23)
    end
  end

  describe '#fire!' do
    it 'creates at least a single bullet object' do
      expect(spaceship.fire!.first).to be_a(Bullet)
    end

    it 'links the bullet to itself' do
      expect(spaceship.fire![0].fired_by).to eq(spaceship)
    end

    it 'sets the position of the bullet right ahead of the spaceship' do
      bullet = spaceship.fire![0]

      expect(bullet.anchor_x).to eq spaceship.anchor_x
      expect(bullet.anchor_y).to eq spaceship.anchor_y
    end
  end
end
