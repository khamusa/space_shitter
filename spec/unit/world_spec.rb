require_relative '../../lib/world'
require_relative '../../lib/world_objects/space_ship'

describe World do
  let(:a_world) { World.new 220, 560 }

  it 'stores width and height, which can be accessed' do
    expect(a_world.width).to eq(220)
    expect(a_world.height).to eq(560)
  end

  describe '#register_objects' do
    it 'adds objects to the objects list' do
      other_objects = [object_a = double, object_b = double]
      a_world.register_objects(other_objects)
      expect(a_world.objects).to eq([object_a, object_b])
    end
  end

  describe '#game_tick' do
    it 'calls #update with tick count on every registered object' do
      spaceship_1 = double
      spaceship_2 = double

      allow(a_world).to receive(:garbage_collect!)

      expect(spaceship_1).to receive(:update).with(0).and_return(true)
      expect(spaceship_2).to receive(:update).with(0).and_return(true)

      a_world.register_objects([spaceship_1, spaceship_2])
      a_world.game_tick
    end

    it 'increments the tick counter' do
      spaceship_1 = double

      allow(a_world).to receive(:garbage_collect!)

      expect(spaceship_1).to receive(:update).with(0).and_return(true)
      expect(spaceship_1).to receive(:update).with(1).and_return(true)
      expect(spaceship_1).to receive(:update).with(2).and_return(true)

      a_world.register_objects([spaceship_1])
      a_world.game_tick
      a_world.game_tick
      a_world.game_tick
    end
  end

  describe '#garbage_collect!' do
    it 'does not remove an object within the screen' do
      spaceship_1 = SpaceShip.new(1, 1, { [0, 0] => '-' })
      a_world.register_objects([ spaceship_1 ])
      a_world.garbage_collect!

      expect(a_world.objects).to include(spaceship_1)
    end

    it 'removes an object that has left the screen' do
      spaceship_1 = SpaceShip.new(0, 1, { [0, 0] => '-' })
      a_world.register_objects([ spaceship_1 ])
      a_world.garbage_collect!

      expect(a_world.objects).not_to include(spaceship_1)
    end
  end
end
