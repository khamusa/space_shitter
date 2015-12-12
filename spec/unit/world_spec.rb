require_relative '../../lib/world'
require_relative '../../lib/world_objects/space_ship'

require 'timecop'

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

    it 'calls #update_objects' do
      expect(a_world).to receive(:update_objects).once

      a_world.game_tick
    end

    it 'calls the #garbage_collect!' do
      expect(a_world).to receive(:garbage_collect!).once

      a_world.game_tick
    end

  end

  describe '#update_objects' do

    it 'is a private method' do
      expect { a_world.update_objects }.to raise_error(NoMethodError)
    end

    it 'calls #update on every object passing time diff since last call' do
      spaceship_1 = double
      spaceship_2 = double

      a_world.current_time = Time.now
      a_world.register_objects([spaceship_1, spaceship_2])

      Timecop.freeze(a_world.current_time + 1) do
        expect(spaceship_1).to receive(:update).with(1).and_return(true)
        expect(spaceship_2).to receive(:update).with(1).and_return(true)

        a_world.send(:update_objects)
      end
    end

    it 'saves a new current_time' do
      a_world.current_time = initial_time = Time.now

      Timecop.freeze(initial_time + 1) do
        a_world.send(:update_objects)

        expect(a_world.current_time).to eq(initial_time + 1)
      end
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
