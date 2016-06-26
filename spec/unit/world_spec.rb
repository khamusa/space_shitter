require 'spec_helper'
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
    before :each do
      allow(a_world).to receive(:test_object_leaving_viewport)
    end

    it 'is a private method' do
      expect { a_world.update_objects }.to raise_error(NoMethodError)
    end

    it 'calls #update_object passing each object and the time diff since last call' do
      spaceship_1 = double
      spaceship_2 = double

      a_world.current_time = Time.now
      a_world.register_objects([spaceship_1, spaceship_2])

      Timecop.freeze(a_world.current_time + 1) do
        expect(a_world).to receive(:update_object).with(spaceship_1, 1.0)
        expect(a_world).to receive(:update_object).with(spaceship_2, 1.0)
        a_world.send(:update_objects)
      end
    end

    it 'checks if each object has left the viewport' do
      spaceship_1 = double(:update => true)
      spaceship_2 = double(:update => true)

      a_world.current_time = Time.now
      a_world.register_objects([spaceship_1, spaceship_2])

      expect(a_world).to receive(:test_object_leaving_viewport).with(spaceship_1)
      expect(a_world).to receive(:test_object_leaving_viewport).with(spaceship_2)

      a_world.send(:update_objects)
    end

    it 'saves a new current_time' do
      a_world.current_time = initial_time = Time.now

      Timecop.freeze(initial_time + 1) do
        a_world.send(:update_objects)

        expect(a_world.current_time).to eq(initial_time + 1)
      end
    end

  end

  describe 'test_object_leaving_viewport' do
    it 'does not send the event to an object within the screen' do
      spaceship_1 = SpaceShip.new(1, 1, { [0, 0] => '-' })
      a_world.register_objects([ spaceship_1 ])

      expect(spaceship_1).not_to receive(:obj_left_viewport!)

      a_world.send(:test_object_leaving_viewport, spaceship_1)
    end

    context 'when an object leave the screen' do
      it 'from the left, sends an "obj_left_viewport!" event to the object with a :left parameter' do
        spaceship_1 = SpaceShip.new(0, 0,
          char_map: { [-1, 0] => '-' })
        a_world.register_objects([ spaceship_1 ])

        expect(spaceship_1).to receive(:obj_left_viewport!).with(:left)

        a_world.send(:test_object_leaving_viewport, spaceship_1)
      end

      it 'from the top, sends an "obj_left_viewport!" event to the object with a :top parameter' do
        spaceship_1 = SpaceShip.new(0, 0,
          char_map: { [0, -1] => '-' })
        a_world.register_objects([ spaceship_1 ])

        expect(spaceship_1).to receive(:obj_left_viewport!).with(:top)

        a_world.send(:test_object_leaving_viewport, spaceship_1)
      end

      it 'from the bottom, sends an "obj_left_viewport!" event to the object with a :bottom parameter' do
        spaceship_1 = SpaceShip.new(0, a_world.height + 1,
          char_map: { [0, 0] => '-' })
        a_world.register_objects([ spaceship_1 ])

        expect(spaceship_1).to receive(:obj_left_viewport!).with(:bottom)

        a_world.send(:test_object_leaving_viewport, spaceship_1)
      end

      it 'from the right, sends an "obj_left_viewport!" event to the object with a :right parameter' do
        spaceship_1 = SpaceShip.new(a_world.width + 1, 0,
          char_map: { [0, 0] => '-' })
        a_world.register_objects([ spaceship_1 ])

        expect(spaceship_1).to receive(:obj_left_viewport!).with(:right)

        a_world.send(:test_object_leaving_viewport, spaceship_1)
      end

      context 'with complex char_maps' do
        it 'takes the char map into consideration when detecting' do
          should_leave_right = SpaceShip.new(a_world.width, 0,
            char_map: { [0, 0] => '--' })
          should_leave_left = SpaceShip.new(0, 0,
            char_map: { [-1, 0] => '-' })
          should_not_leave1 = SpaceShip.new(a_world.width, 0,
            char_map: { [0, 0] => '-' })
          should_not_leave2 = SpaceShip.new(0, 0,
            char_map: { [0, 0] => '-' })

          a_world.register_objects([
            should_leave_right, should_leave_left,
            should_not_leave1, should_not_leave2 ])

          expect(should_leave_right).to receive(:obj_left_viewport!).with(:right)
          expect(should_leave_left).to receive(:obj_left_viewport!).with(:left)
          expect(should_not_leave1).not_to receive(:obj_left_viewport!)
          expect(should_not_leave2).not_to receive(:obj_left_viewport!)

          a_world.send(:test_object_leaving_viewport, should_leave_right)
          a_world.send(:test_object_leaving_viewport, should_leave_left)
          a_world.send(:test_object_leaving_viewport, should_not_leave1)
          a_world.send(:test_object_leaving_viewport, should_not_leave2)
        end
      end
    end

  end

  describe '#update_object' do
    it 'is a private method' do
      expect { a_world.update_object(double(:update => true), 2) }.to raise_error(NoMethodError)
    end

    it 'calls the object\'s update method passing the supplied time diff' do
      obj = double

      expect(obj).to receive(:update).with(1.3)
      a_world.send(:update_object, obj, 1.3)
    end
  end

  describe '#garbage_collect!' do
    it 'removes objects that have been destroyed' do
      spaceship_1 = SpaceShip.new(1, 1)
      spaceship_1.destroy!
      a_world.register_objects([ spaceship_1 ])
      a_world.garbage_collect!

      expect(a_world.objects).not_to include(spaceship_1)
    end

    it 'does not remove objects that have not been destroyed' do
      spaceship_1 = SpaceShip.new(1, 1)
      a_world.register_objects([ spaceship_1 ])
      a_world.garbage_collect!

      expect(a_world.objects).to include(spaceship_1)
    end
  end
end
