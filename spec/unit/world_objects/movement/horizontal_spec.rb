require 'spec_helper'
require 'world_object'
require 'world_objects/movement/horizontal'

describe WorldObjects::Movement::Horizontal do
  let(:object_klass) do
    Class.new do
      include WorldObject
      include WorldObjects::Movement::Horizontal
    end
  end

  let(:an_instance) { object_klass.new(0, 0) }

  it 'has an accessor for hor_speed' do
    expect { an_instance.hor_speed }.not_to raise_error
  end

  describe '#update' do

    it 'moves the object horizontally according to the defined horizontal speed' do
      expect(an_instance).to receive(:move).with(1, 0)

      an_instance.hor_speed = 1
      an_instance.update(1)
    end

    it 'moves the object proportionally to the time passed' do
      expect(an_instance).to receive(:move).with(0.8, 0)

      an_instance.hor_speed = 1
      an_instance.update(0.8)
    end

    it 'does not move the object if no time has passed' do
      expect(an_instance).to receive(:move).with(0, 0)

      an_instance.hor_speed = 1
      an_instance.update(0)
    end

  end
end
