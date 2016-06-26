require 'spec_helper'
require 'world_object'
require 'world_objects/movement/sinusoidal.rb'

describe WorldObjects::Movement::Sinusoidal do
  let(:object_klass) do
    Class.new do
      include WorldObject
      include WorldObjects::Movement::Sinusoidal
    end
  end

  let(:an_instance) { object_klass.new(0, 0) }

  [ :amplitude, :frequency ].each do |accessor|
    it "has an accessor for #{accessor}" do
      expect { an_instance.send(accessor) }.not_to raise_error
    end

    it "has a default #{accessor} of 1" do
      expect(an_instance.send(accessor)).to eq(1)
    end
  end

  describe '#update' do

    context 'when time passed is Math::PI/2' do
      it 'moves the object up of the value of amplitude' do
        an_instance.amplitude = 2

        expect(an_instance).to receive(:anchor_y=).with(2.0)
        an_instance.update(Math::PI/2)
      end

      it 'wont move the object if frequency is double' do
        an_instance.amplitude = 2
        an_instance.frequency = 2

        expect(an_instance).to receive(:anchor_y=) do |y|
          expect(y.abs).to be < Float::EPSILON * 1.5 # 1.5 is arbitrary
        end

        an_instance.update(Math::PI/2)
      end

      it 'if another Math::PI time has passed, it moves the object down of amplitude' do
        an_instance.amplitude = 3

        expect(an_instance).to receive(:anchor_y=).with(3)
        an_instance.update(Math::PI/2)

        expect(an_instance).to receive(:anchor_y=).with(-3)
        an_instance.update(Math::PI)
      end
    end
  end
end
